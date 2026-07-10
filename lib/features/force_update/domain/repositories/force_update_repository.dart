import '../models/force_update_info.dart';

abstract class ForceUpdateRepository {
  Future<ForceUpdateInfo> check();
}
