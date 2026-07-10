abstract class PermissionNoticeRepository {
  Future<bool> hasSeenNotice();
  Future<void> markSeen();
}
