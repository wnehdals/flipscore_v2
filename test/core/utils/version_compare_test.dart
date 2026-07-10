import 'package:flutter_test/flutter_test.dart';
import 'package:flipscore/core/utils/version_compare.dart';

void main() {
  group('isVersionBelow', () {
    test('현재 버전이 최소 버전과 같으면 false', () {
      expect(isVersionBelow('1.2.0', '1.2.0'), isFalse);
    });

    test('현재 버전이 최소 버전보다 낮으면 true', () {
      expect(isVersionBelow('1.1.9', '1.2.0'), isTrue);
    });

    test('현재 버전이 최소 버전보다 높으면 false', () {
      expect(isVersionBelow('2.0.0', '1.2.0'), isFalse);
    });

    test('세그먼트 개수가 다를 때 짧은 쪽은 0으로 채워 비교한다', () {
      expect(isVersionBelow('1.2', '1.2.0'), isFalse);
      expect(isVersionBelow('1.2', '1.2.0.1'), isTrue);
      expect(isVersionBelow('1.2.0.1', '1.2'), isFalse);
    });

    test('형식이 잘못된 값은 사용자를 막지 않기 위해 false를 반환한다', () {
      expect(isVersionBelow('1.2.0', 'invalid'), isFalse);
      expect(isVersionBelow('invalid', '1.2.0'), isFalse);
      expect(isVersionBelow('', ''), isFalse);
    });
  });
}
