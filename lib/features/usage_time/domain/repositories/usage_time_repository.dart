import '../../../../shared/models/usage_time.dart';

abstract interface class UsageTimeRepository {
  Stream<UsageTime?> watchUsageTime(String docId);
  Future<UsageTime?> getUsageTime(String docId);
  Future<void> updateUsageTime(String docId, UsageTime usageTime);
}
