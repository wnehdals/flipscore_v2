import 'package:flutter_test/flutter_test.dart';
import 'package:flipscore/features/viewer/domain/services/eye_gesture_recognizer.dart';
import 'package:flipscore/shared/models/enums.dart';

void main() {
  group('EyeGestureRecognizer', () {
    test('winkHoldFrames 미만으로 감겼다 뜨면 트리거되지 않는다', () {
      final recognizer = EyeGestureRecognizer(winkHoldFrames: 3);
      final now = DateTime(2026, 1, 1);

      for (var i = 0; i < 2; i++) {
        final result = recognizer.process(
          leftEyeOpenProb: 0.9,
          rightEyeOpenProb: 0.1,
          now: now.add(Duration(milliseconds: i * 100)),
        );
        expect(result, isNull);
      }

      final result = recognizer.process(
        leftEyeOpenProb: 0.9,
        rightEyeOpenProb: 0.9,
        now: now.add(const Duration(milliseconds: 300)),
      );
      expect(result, isNull);
    });

    test('오른쪽 눈이 winkHoldFrames 이상 감겼다 뜨면 rightWink가 트리거된다', () {
      final recognizer = EyeGestureRecognizer(winkHoldFrames: 2);
      final now = DateTime(2026, 1, 1);

      recognizer.process(
        leftEyeOpenProb: 0.9,
        rightEyeOpenProb: 0.1,
        now: now,
      );
      recognizer.process(
        leftEyeOpenProb: 0.9,
        rightEyeOpenProb: 0.1,
        now: now.add(const Duration(milliseconds: 100)),
      );
      final result = recognizer.process(
        leftEyeOpenProb: 0.9,
        rightEyeOpenProb: 0.9,
        now: now.add(const Duration(milliseconds: 200)),
      );

      expect(result, GestureType.rightWink);
    });

    test('두 번째 깜빡임이 blinkWindow를 벗어나면 blink가 트리거되지 않는다', () {
      final recognizer = EyeGestureRecognizer(
        blinkWindow: const Duration(milliseconds: 500),
        cooldown: Duration.zero,
      );
      final now = DateTime(2026, 1, 1);

      recognizer.process(
        leftEyeOpenProb: 0.1,
        rightEyeOpenProb: 0.1,
        now: now,
      );
      recognizer.process(
        leftEyeOpenProb: 0.9,
        rightEyeOpenProb: 0.9,
        now: now.add(const Duration(milliseconds: 100)),
      );

      final second = now.add(const Duration(seconds: 2));
      recognizer.process(
        leftEyeOpenProb: 0.1,
        rightEyeOpenProb: 0.1,
        now: second,
      );
      final result = recognizer.process(
        leftEyeOpenProb: 0.9,
        rightEyeOpenProb: 0.9,
        now: second.add(const Duration(milliseconds: 100)),
      );

      expect(result, isNull);
    });

    test('blinkWindow 안에서 두 번 깜빡이면 blink가 트리거된다', () {
      final recognizer = EyeGestureRecognizer(
        blinkWindow: const Duration(milliseconds: 1500),
        cooldown: Duration.zero,
      );
      final now = DateTime(2026, 1, 1);

      recognizer.process(
        leftEyeOpenProb: 0.1,
        rightEyeOpenProb: 0.1,
        now: now,
      );
      recognizer.process(
        leftEyeOpenProb: 0.9,
        rightEyeOpenProb: 0.9,
        now: now.add(const Duration(milliseconds: 100)),
      );

      final second = now.add(const Duration(milliseconds: 500));
      recognizer.process(
        leftEyeOpenProb: 0.1,
        rightEyeOpenProb: 0.1,
        now: second,
      );
      final result = recognizer.process(
        leftEyeOpenProb: 0.9,
        rightEyeOpenProb: 0.9,
        now: second.add(const Duration(milliseconds: 100)),
      );

      expect(result, GestureType.blink);
    });

    test('쿨다운 중에는 두 번째 제스처가 무시된다', () {
      final recognizer = EyeGestureRecognizer(
        winkHoldFrames: 1,
        cooldown: const Duration(seconds: 2),
      );
      final now = DateTime(2026, 1, 1);

      recognizer.process(
        leftEyeOpenProb: 0.9,
        rightEyeOpenProb: 0.1,
        now: now,
      );
      final firstTrigger = recognizer.process(
        leftEyeOpenProb: 0.9,
        rightEyeOpenProb: 0.9,
        now: now.add(const Duration(milliseconds: 100)),
      );
      expect(firstTrigger, GestureType.rightWink);

      final withinCooldown = now.add(const Duration(milliseconds: 500));
      recognizer.process(
        leftEyeOpenProb: 0.9,
        rightEyeOpenProb: 0.1,
        now: withinCooldown,
      );
      final result = recognizer.process(
        leftEyeOpenProb: 0.9,
        rightEyeOpenProb: 0.9,
        now: withinCooldown.add(const Duration(milliseconds: 100)),
      );

      expect(result, isNull);
    });
  });
}
