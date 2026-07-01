import '../../../../shared/models/payment.dart';
import '../../../../shared/models/subscription.dart';

abstract interface class SubscriptionRepository {
  Stream<Subscription> watchSubscription(String docId);
  Future<Subscription> getSubscription(String docId);
  Future<void> createPayment({required String docId, required Payment payment});
}
