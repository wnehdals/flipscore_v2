import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../shared/models/usage_time.dart';
import '../../domain/repositories/usage_time_repository.dart';

class FirestoreUsageTimeRepository implements UsageTimeRepository {
  FirestoreUsageTimeRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  DocumentReference _ref(String docId) => _firestore
      .collection('users')
      .doc(docId)
      .collection('usageTime')
      .doc('current');

  @override
  Stream<UsageTime?> watchUsageTime(String docId) {
    return _ref(docId).snapshots().map((snap) {
      if (!snap.exists || snap.data() == null) return null;
      return _fromMap(docId, snap.data()! as Map<String, dynamic>);
    });
  }

  @override
  Future<UsageTime?> getUsageTime(String docId) async {
    final snap = await _ref(docId).get();
    if (!snap.exists || snap.data() == null) return null;
    return _fromMap(docId, snap.data()! as Map<String, dynamic>);
  }

  @override
  Future<void> updateUsageTime(String docId, UsageTime usageTime) async {
    await _ref(docId).set({
      'remainingSeconds': usageTime.remainingSeconds,
      'adsWatchedToday': usageTime.adsWatchedToday,
      'lastAdDate': Timestamp.fromDate(usageTime.lastAdDate),
      'updatedAt': Timestamp.fromDate(usageTime.updatedAt),
    });
  }

  UsageTime _fromMap(String docId, Map<String, dynamic> data) => UsageTime(
        userId: docId,
        remainingSeconds: (data['remainingSeconds'] as num?)?.toInt() ?? 0,
        adsWatchedToday: (data['adsWatchedToday'] as num?)?.toInt() ?? 0,
        lastAdDate: _toDateTime(data['lastAdDate']) ?? DateTime(2000),
        updatedAt: _toDateTime(data['updatedAt']) ?? DateTime.now(),
      );

  DateTime? _toDateTime(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}
