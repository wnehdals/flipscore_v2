import 'package:shared_preferences/shared_preferences.dart';

import '../../../../shared/models/enums.dart';
import '../../domain/repositories/gesture_sensitivity_repository.dart';

class SharedPrefsGestureSensitivityRepository
    implements GestureSensitivityRepository {
  static const _key = 'gesture_sensitivity';

  @override
  Future<GestureSensitivity> load() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString(_key);
    return GestureSensitivity.values.firstWhere(
      (e) => e.name == name,
      orElse: () => GestureSensitivity.medium,
    );
  }

  @override
  Future<void> save(GestureSensitivity sensitivity) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, sensitivity.name);
  }
}
