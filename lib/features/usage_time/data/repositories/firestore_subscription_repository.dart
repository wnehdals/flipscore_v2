import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../shared/models/enums.dart';
import '../../../../shared/models/payment.dart';
import '../../../../shared/models/subscription.dart';
import '../../domain/repositories/subscription_repository.dart';

class FirestoreSubscriptionRepository implements SubscriptionRepository {
  FirestoreSubscriptionRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  DocumentReference _subRef(String docId) => _firestore
      .collection('users')
      .doc(docId)
      .collection('subscription')
      .doc('current');

  @override
  Stream<Subscription> watchSubscription(String docId) {
    return _subRef(docId).snapshots().map((snap) =>
        snap.exists && snap.data() != null
            ? _fromMap(snap.data()! as Map<String, dynamic>)
            : Subscription.initial());
  }

  @override
  Future<Subscription> getSubscription(String docId) async {
    final snap = await _subRef(docId).get();
    if (!snap.exists || snap.data() == null) return Subscription.initial();
    return _fromMap(snap.data()! as Map<String, dynamic>);
  }

  @override
  Future<void> createPayment({
    required String docId,
    required Payment payment,
  }) async {
    await _firestore
        .collection('users')
        .doc(docId)
        .collection('payments')
        .doc(payment.transactionId)
        .set({
      'transactionId': payment.transactionId,
      'productId': payment.productId,
      'platform': payment.platform,
      'purchaseToken': payment.purchaseToken,
      'receiptData': payment.receiptData,
      'verificationStatus': payment.verificationStatus.name,
      'type': payment.type,
      'createdAt': Timestamp.fromDate(payment.createdAt),
      'verifiedAt': payment.verifiedAt != null
          ? Timestamp.fromDate(payment.verifiedAt!)
          : null,
    });
  }

  Subscription _fromMap(Map<String, dynamic> data) => Subscription(
        status: SubscriptionStatus.values.byName(
          data['status'] as String? ?? 'none',
        ),
        platform: data['platform'] as String?,
        productId: data['productId'] as String?,
        originalTransactionId: data['originalTransactionId'] as String?,
        purchaseToken: data['purchaseToken'] as String?,
        startedAt: _toDateTime(data['startedAt']),
        expiresAt: _toDateTime(data['expiresAt']),
        renewedAt: _toDateTime(data['renewedAt']),
        cancelledAt: _toDateTime(data['cancelledAt']),
        autoRenewing: data['autoRenewing'] as bool? ?? false,
        verifiedAt: _toDateTime(data['verifiedAt']),
      );

  DateTime? _toDateTime(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}
