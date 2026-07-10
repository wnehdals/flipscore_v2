import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/shared_prefs_permission_notice_repository.dart';
import '../../domain/repositories/permission_notice_repository.dart';

part 'permission_notice_provider.g.dart';

@Riverpod(keepAlive: true)
PermissionNoticeRepository permissionNoticeRepository(Ref ref) =>
    SharedPrefsPermissionNoticeRepository();

@Riverpod(keepAlive: true)
class PermissionNoticeSeen extends _$PermissionNoticeSeen {
  @override
  Future<bool> build() {
    return ref.watch(permissionNoticeRepositoryProvider).hasSeenNotice();
  }

  /// Returns true on success. On failure, state becomes AsyncError and
  /// false is returned so the caller can surface a retry affordance.
  Future<bool> markSeen() async {
    try {
      await ref.read(permissionNoticeRepositoryProvider).markSeen();
      state = const AsyncData(true);
      return true;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }
}
