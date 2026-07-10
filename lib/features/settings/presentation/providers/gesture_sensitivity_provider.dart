import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../shared/models/enums.dart';
import '../../data/repositories/shared_prefs_gesture_sensitivity_repository.dart';
import '../../domain/repositories/gesture_sensitivity_repository.dart';

part 'gesture_sensitivity_provider.g.dart';

@Riverpod(keepAlive: true)
GestureSensitivityRepository gestureSensitivityRepository(Ref ref) =>
    SharedPrefsGestureSensitivityRepository();

@Riverpod(keepAlive: true)
class GestureSensitivityController extends _$GestureSensitivityController {
  @override
  Future<GestureSensitivity> build() {
    return ref.read(gestureSensitivityRepositoryProvider).load();
  }

  Future<void> setSensitivity(GestureSensitivity sensitivity) async {
    state = AsyncData(sensitivity);
    await ref
        .read(gestureSensitivityRepositoryProvider)
        .save(sensitivity);
  }
}
