import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../shared/models/usage_time.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/repositories/firestore_usage_time_repository.dart';
import '../../domain/repositories/usage_time_repository.dart';

part 'usage_time_provider.g.dart';

@Riverpod(keepAlive: true)
UsageTimeRepository usageTimeRepository(Ref ref) =>
    FirestoreUsageTimeRepository();

@riverpod
Stream<UsageTime?> currentUsageTime(Ref ref) {
  final authAsync = ref.watch(authStateProvider);
  final docId = authAsync.valueOrNull?.docId;
  if (docId == null) return Stream.value(null);
  return ref.read(usageTimeRepositoryProvider).watchUsageTime(docId);
}
