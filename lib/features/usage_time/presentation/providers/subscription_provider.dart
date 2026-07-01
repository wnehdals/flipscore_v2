import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../shared/models/subscription.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/repositories/firestore_subscription_repository.dart';
import '../../domain/repositories/subscription_repository.dart';

part 'subscription_provider.g.dart';

@Riverpod(keepAlive: true)
SubscriptionRepository subscriptionRepository(Ref ref) =>
    FirestoreSubscriptionRepository();

@Riverpod(keepAlive: true)
Stream<Subscription> currentSubscription(Ref ref) {
  final authAsync = ref.watch(authStateProvider);
  final docId = authAsync.valueOrNull?.docId;
  if (docId == null) return Stream.value(Subscription.initial());
  return ref.read(subscriptionRepositoryProvider).watchSubscription(docId);
}
