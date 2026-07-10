import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/remote_config_force_update_repository.dart';
import '../../domain/models/force_update_info.dart';
import '../../domain/repositories/force_update_repository.dart';

part 'force_update_provider.g.dart';

@Riverpod(keepAlive: true)
ForceUpdateRepository forceUpdateRepository(Ref ref) =>
    RemoteConfigForceUpdateRepository();

@Riverpod(keepAlive: true)
Future<ForceUpdateInfo> forceUpdateCheck(Ref ref) {
  return ref.watch(forceUpdateRepositoryProvider).check();
}
