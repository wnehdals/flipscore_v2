import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/repositories/permission_notice_repository.dart';

class SharedPrefsPermissionNoticeRepository
    implements PermissionNoticeRepository {
  static const _key = 'permission_notice_seen';

  @override
  Future<bool> hasSeenNotice() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_key) ?? false;
  }

  @override
  Future<void> markSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, true);
  }
}
