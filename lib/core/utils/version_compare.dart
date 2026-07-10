/// [current]가 [min]보다 낮은 버전인지 비교한다.
///
/// 버전 형식이 잘못되어 파싱에 실패하면 사용자를 막지 않기 위해 `false`를 반환한다.
bool isVersionBelow(String current, String min) {
  try {
    final currentParts = current.split('.').map(int.parse).toList();
    final minParts = min.split('.').map(int.parse).toList();
    final length = currentParts.length > minParts.length
        ? currentParts.length
        : minParts.length;
    for (var i = 0; i < length; i++) {
      final c = i < currentParts.length ? currentParts[i] : 0;
      final m = i < minParts.length ? minParts[i] : 0;
      if (c != m) return c < m;
    }
    return false;
  } catch (_) {
    return false;
  }
}
