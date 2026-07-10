import '../../../../shared/models/enums.dart';

abstract interface class GestureSensitivityRepository {
  Future<GestureSensitivity> load();
  Future<void> save(GestureSensitivity sensitivity);
}
