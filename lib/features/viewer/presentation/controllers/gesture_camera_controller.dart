import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

import '../../../../core/utils/app_logger.dart';
import '../../../../shared/models/enums.dart';
import '../../domain/services/eye_gesture_recognizer.dart';

const _rotationByDeviceOrientation = {
  DeviceOrientation.portraitUp: 0,
  DeviceOrientation.landscapeLeft: 90,
  DeviceOrientation.portraitDown: 180,
  DeviceOrientation.landscapeRight: 270,
};

/// 전면 카메라 스트림을 ML Kit 얼굴 인식에 연결해
/// 눈 제스처를 감지하고 [onGesture]로 알려주는 컨트롤러.
///
/// [start]/[stop]은 앱 라이프사이클(백그라운드 전환·재개)에 따라 여러 곳에서
/// 겹쳐 호출될 수 있으므로, `_generation` 토큰으로 이전 세션의 프레임 콜백을
/// 무시하고 `_startFuture`로 동시 start() 호출을 하나로 합친다.
class GestureCameraController {
  GestureCameraController({
    required this.onGesture,
    GestureSensitivity sensitivity = GestureSensitivity.medium,
  }) : _recognizer = sensitivity.buildRecognizer();

  final void Function(GestureType gesture) onGesture;

  CameraController? _cameraController;
  FaceDetector? _faceDetector;
  CameraDescription? _cameraDescription;
  final EyeGestureRecognizer _recognizer;

  Future<bool>? _startFuture;
  Future<void>? _inFlightDetection;
  int _generation = 0;
  bool _active = false;
  bool _disposed = false;
  bool _loggedFormatMismatch = false;
  DateTime? _lastProbLogAt;

  bool get isActive => _active;

  /// 카메라 초기화 및 스트리밍 시작. 실패 시 false를 반환한다.
  /// 이미 시작 중이면 진행 중인 Future를 그대로 반환해 중복 초기화를 막는다.
  Future<bool> start() {
    if (_disposed) return Future.value(false);
    if (_active) return Future.value(true);
    return _startFuture ??= _start().whenComplete(() => _startFuture = null);
  }

  Future<bool> _start() async {
    final generation = ++_generation;
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        appLogger.w('[GestureCamera] 사용 가능한 카메라가 없습니다');
        return false;
      }
      final front = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      final detector = FaceDetector(
        options: FaceDetectorOptions(
          enableClassification: true,
          performanceMode: FaceDetectorMode.fast,
        ),
      );
      final controller = CameraController(
        front,
        ResolutionPreset.low,
        enableAudio: false,
        imageFormatGroup:
            Platform.isAndroid ? ImageFormatGroup.nv21 : ImageFormatGroup.bgra8888,
      );
      await controller.initialize();

      // stop()이 초기화 도중 먼저 호출되었다면 이 세션은 버린다.
      if (_disposed || generation != _generation) {
        appLogger.i('[GestureCamera] 초기화 도중 취소되어 세션을 폐기합니다');
        await controller.dispose();
        await detector.close();
        return false;
      }

      _cameraDescription = front;
      _faceDetector = detector;
      _cameraController = controller;
      await controller.startImageStream((image) => _onFrame(image, generation));

      // 스트리밍 시작 직후(예: 스트림 시작 대기 중 홈 버튼으로 stop()이 먼저 끝난 경우)
      // 세션이 이미 무효화됐다면 방금 연 카메라를 즉시 정리하고 active로 표시하지 않는다.
      if (_disposed || generation != _generation) {
        appLogger.i('[GestureCamera] 스트리밍 시작 직후 취소되어 세션을 정리합니다');
        await _teardown();
        return false;
      }

      _active = true;
      appLogger.i(
        '[GestureCamera] 카메라 시작 성공 (lens=${front.lensDirection.name}, gen=$generation)',
      );
      return true;
    } catch (e, st) {
      appLogger.e('[GestureCamera] 카메라 시작 실패', error: e, stackTrace: st);
      await _teardown();
      return false;
    }
  }

  /// 카메라/감지기를 정지하고 리소스를 해제한다.
  /// in-flight 상태(start 진행 중, 프레임 처리 중)를 모두 기다린 뒤 정리한다.
  Future<void> stop() async {
    if (!_active && _startFuture == null) return;
    _generation++;
    _active = false;
    await _startFuture;
    await _inFlightDetection;
    await _teardown();
    appLogger.i('[GestureCamera] 카메라 정지');
  }

  Future<void> dispose() async {
    _disposed = true;
    await stop();
  }

  Future<void> _teardown() async {
    final controller = _cameraController;
    _cameraController = null;
    try {
      if (controller != null && controller.value.isStreamingImages) {
        await controller.stopImageStream();
      }
    } catch (_) {}
    try {
      await controller?.dispose();
    } catch (_) {}
    try {
      await _faceDetector?.close();
    } catch (_) {}
    _faceDetector = null;
    _cameraDescription = null;
  }

  void _onFrame(CameraImage image, int generation) {
    if (generation != _generation) return;
    if (_inFlightDetection != null) return;
    final future = _detectFaces(image, generation);
    _inFlightDetection = future;
    future.whenComplete(() {
      if (identical(_inFlightDetection, future)) _inFlightDetection = null;
    });
  }

  Future<void> _detectFaces(CameraImage image, int generation) async {
    final detector = _faceDetector;
    if (detector == null) return;
    final inputImage = _toInputImage(image);
    if (inputImage == null) return;
    try {
      final faces = await detector.processImage(inputImage);
      // 감지 중 stop()/restart로 세션이 바뀌었다면 결과를 버린다.
      if (generation != _generation) return;
      if (faces.isEmpty) return;
      final face = faces.first;
      final leftProb = face.leftEyeOpenProbability;
      final rightProb = face.rightEyeOpenProbability;

      if (kDebugMode) {
        final now = DateTime.now();
        if (_lastProbLogAt == null ||
            now.difference(_lastProbLogAt!) > const Duration(milliseconds: 500)) {
          _lastProbLogAt = now;
          appLogger.d(
            '[GestureCamera] eyeL=${leftProb?.toStringAsFixed(2)} '
            'eyeR=${rightProb?.toStringAsFixed(2)}',
          );
        }
      }

      final gesture = _recognizer.process(
        leftEyeOpenProb: leftProb,
        rightEyeOpenProb: rightProb,
      );
      if (gesture != null) {
        appLogger.i('[GestureCamera] 제스처 감지: $gesture');
        onGesture(gesture);
      }
    } catch (e, st) {
      appLogger.e('[GestureCamera] 얼굴 인식 실패', error: e, stackTrace: st);
    }
  }

  InputImage? _toInputImage(CameraImage image) {
    final camera = _cameraDescription;
    final controller = _cameraController;
    if (camera == null || controller == null) return null;

    final sensorOrientation = camera.sensorOrientation;
    InputImageRotation? rotation;
    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else if (Platform.isAndroid) {
      var rotationCompensation =
          _rotationByDeviceOrientation[controller.value.deviceOrientation];
      if (rotationCompensation == null) return null;
      if (camera.lensDirection == CameraLensDirection.front) {
        rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
      } else {
        rotationCompensation =
            (sensorOrientation - rotationCompensation + 360) % 360;
      }
      rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
    }
    if (rotation == null) return null;

    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    final formatMismatch = format == null ||
        (Platform.isAndroid && format != InputImageFormat.nv21) ||
        (Platform.isIOS && format != InputImageFormat.bgra8888);
    if (formatMismatch) {
      if (!_loggedFormatMismatch) {
        _loggedFormatMismatch = true;
        appLogger.w(
          '[GestureCamera] 예상치 못한 이미지 포맷(${image.format.raw}) - 제스처 인식이 동작하지 않습니다',
        );
      }
      return null;
    }

    if (image.planes.length != 1) {
      if (!_loggedFormatMismatch) {
        _loggedFormatMismatch = true;
        appLogger.w(
          '[GestureCamera] 예상치 못한 plane 개수(${image.planes.length}) - 제스처 인식이 동작하지 않습니다',
        );
      }
      return null;
    }
    final plane = image.planes.first;

    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: plane.bytesPerRow,
      ),
    );
  }
}
