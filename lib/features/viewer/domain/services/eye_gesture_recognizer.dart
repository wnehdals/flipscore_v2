import '../../../../shared/models/enums.dart';

/// ML Kit이 프레임마다 내려주는 눈 뜬 확률 값을 받아
/// 윙크·두 번 깜빡임 제스처를 판별하는 상태 머신.
///
/// 카메라/ML Kit에 대한 의존성이 없는 순수 로직이라 단위 테스트가 쉽다.
class EyeGestureRecognizer {
  EyeGestureRecognizer({
    this.eyeClosedThreshold = 0.35,
    this.eyeOpenThreshold = 0.6,
    this.winkHoldFrames = 2,
    this.blinkWindow = const Duration(milliseconds: 1500),
    this.cooldown = const Duration(seconds: 2),
  });

  final double eyeClosedThreshold;
  final double eyeOpenThreshold;
  final int winkHoldFrames;
  final Duration blinkWindow;
  final Duration cooldown;

  int _rightClosedStreak = 0;
  int _leftClosedStreak = 0;
  bool _bothWereClosed = false;
  final List<DateTime> _blinkTimestamps = [];
  DateTime? _lastTrigger;

  /// 감지된 제스처가 있으면 [GestureType]을, 없으면 null을 반환한다.
  GestureType? process({
    required double? leftEyeOpenProb,
    required double? rightEyeOpenProb,
    DateTime? now,
  }) {
    final ts = now ?? DateTime.now();
    if (_lastTrigger != null && ts.difference(_lastTrigger!) < cooldown) {
      return null;
    }

    final left = leftEyeOpenProb;
    final right = rightEyeOpenProb;
    if (left == null || right == null) {
      _rightClosedStreak = 0;
      _leftClosedStreak = 0;
      return null;
    }

    final leftClosed = left <= eyeClosedThreshold;
    final rightClosed = right <= eyeClosedThreshold;
    final bothOpen = left >= eyeOpenThreshold && right >= eyeOpenThreshold;
    final bothClosed = leftClosed && rightClosed;

    // 윙크: 한쪽 눈만 일정 프레임 이상 감겼다가 다시 둘 다 뜸
    if (rightClosed && !leftClosed) {
      _rightClosedStreak++;
      _leftClosedStreak = 0;
    } else if (leftClosed && !rightClosed) {
      _leftClosedStreak++;
      _rightClosedStreak = 0;
    } else {
      if (bothOpen && _rightClosedStreak >= winkHoldFrames) {
        return _trigger(GestureType.rightWink, ts);
      }
      if (bothOpen && _leftClosedStreak >= winkHoldFrames) {
        return _trigger(GestureType.leftWink, ts);
      }
      _rightClosedStreak = 0;
      _leftClosedStreak = 0;
    }

    // 두 번 깜빡임: 두 눈이 짧게 감겼다 뜨이는 동작이 시간 창 내에 두 번
    if (bothClosed) {
      _bothWereClosed = true;
    } else if (bothOpen && _bothWereClosed) {
      _bothWereClosed = false;
      _blinkTimestamps.add(ts);
      _blinkTimestamps.removeWhere((t) => ts.difference(t) > blinkWindow);
      if (_blinkTimestamps.length >= 2) {
        return _trigger(GestureType.blink, ts);
      }
    }

    return null;
  }

  GestureType _trigger(GestureType type, DateTime ts) {
    _lastTrigger = ts;
    _rightClosedStreak = 0;
    _leftClosedStreak = 0;
    _bothWereClosed = false;
    _blinkTimestamps.clear();
    return type;
  }
}

/// 설정 화면에서 선택한 감지 민감도를 [EyeGestureRecognizer] 임계값으로 변환한다.
/// 민감도가 높을수록 눈을 살짝만 감아도 감지되고, 홀드 프레임 수가 줄어든다.
extension GestureSensitivityConfig on GestureSensitivity {
  EyeGestureRecognizer buildRecognizer() {
    return switch (this) {
      GestureSensitivity.low => EyeGestureRecognizer(
          eyeClosedThreshold: 0.20,
          eyeOpenThreshold: 0.75,
          winkHoldFrames: 3,
        ),
      GestureSensitivity.medium => EyeGestureRecognizer(),
      GestureSensitivity.high => EyeGestureRecognizer(
          eyeClosedThreshold: 0.50,
          eyeOpenThreshold: 0.55,
          winkHoldFrames: 1,
        ),
    };
  }

  String get label => switch (this) {
        GestureSensitivity.low => '낮음',
        GestureSensitivity.medium => '보통',
        GestureSensitivity.high => '높음',
      };
}
