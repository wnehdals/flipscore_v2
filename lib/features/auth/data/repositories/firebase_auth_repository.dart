import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/utils/uid_encryptor.dart';
import '../../../../shared/models/enums.dart';
import '../../domain/models/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/social_login_datasource.dart';

class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository({
    FirebaseFirestore? firestore,
    SocialLoginDataSource? socialLoginDataSource,
    UidEncryptor? uidEncryptor,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _socialLogin = socialLoginDataSource ?? SocialLoginDataSourceImpl(),
        _encryptor = uidEncryptor ??
            UidEncryptor(
              const String.fromEnvironment('FIRESTORE_UID_KEY'),
            ) {
    _initialize();
  }

  final FirebaseFirestore _firestore;
  final SocialLoginDataSource _socialLogin;
  final UidEncryptor _encryptor;

  AppUser? _currentUser;
  final _controller = StreamController<AppUser?>.broadcast();

  @override
  AppUser? get currentUser => _currentUser;

  @override
  Stream<AppUser?> get authStateChanges => _controller.stream;

  Future<void> _initialize() async {
    final restored = await _socialLogin.tryRestoreSession();
    if (restored == null) {
      _controller.add(null);
      return;
    }
    final user = await _buildUser(restored, checkFirestore: true);
    _currentUser = user;
    _controller.add(user);
  }

  @override
  Future<AppUser> signInWithKakao() async {
    final kakaoResult = await _socialLogin.getKakaoUser();
    final identifier = _identifier(kakaoResult);
    final docId = _encryptor.toDocId('kakao', identifier);

    final doc = await _firestore.collection('users').doc(docId).get();
    final isNew = !doc.exists;

    final user = AppUser(
      kakaoId: kakaoResult.kakaoUserId.toString(),
      docId: docId,
      email: kakaoResult.email,
      displayName: kakaoResult.displayName,
      photoUrl: kakaoResult.photoUrl,
      provider: SocialProvider.kakao,
      isFirstLogin: isNew,
    );

    if (isNew) await _ensureUserDoc(user);

    _currentUser = user;
    _controller.add(user);
    return user;
  }

  @override
  Future<void> signOut() async {
    _currentUser = null;
    await _socialLogin.signOut();
    _controller.add(null);
  }

  @override
  Future<void> deleteAccount() async {
    final user = _currentUser;
    if (user == null) return;
    await _firestore.collection('users').doc(user.docId).delete();
    await signOut();
  }

  @override
  Future<void> completeOnboarding() async {
    final user = _currentUser;
    if (user == null) return;
    await _firestore.collection('users').doc(user.docId).set(
      {'isFirstLogin': false, 'updatedAt': FieldValue.serverTimestamp()},
      SetOptions(merge: true),
    );
    _currentUser = user.copyWith(isFirstLogin: false);
    _controller.add(_currentUser);
  }

  Future<AppUser> _buildUser(
    KakaoLoginResult kakaoResult, {
    bool checkFirestore = false,
  }) async {
    final identifier = _identifier(kakaoResult);
    final docId = _encryptor.toDocId('kakao', identifier);

    bool isFirstLogin = false;
    if (checkFirestore) {
      final doc = await _firestore.collection('users').doc(docId).get();
      isFirstLogin = doc.exists
          ? (doc.data()?['isFirstLogin'] as bool? ?? false)
          : true;
    }

    return AppUser(
      kakaoId: kakaoResult.kakaoUserId.toString(),
      docId: docId,
      email: kakaoResult.email,
      displayName: kakaoResult.displayName,
      photoUrl: kakaoResult.photoUrl,
      provider: SocialProvider.kakao,
      isFirstLogin: isFirstLogin,
    );
  }

  Future<void> _ensureUserDoc(AppUser user) async {
    final now = FieldValue.serverTimestamp();
    final batch = _firestore.batch();

    final userRef = _firestore.collection('users').doc(user.docId);
    batch.set(userRef, {
      'docId': user.docId,
      'kakaoId': user.kakaoId,
      'email': user.email,
      'displayName': user.displayName,
      'photoUrl': user.photoUrl,
      'provider': SocialProvider.kakao.name,
      'isFirstLogin': true,
      'createdAt': now,
      'updatedAt': now,
    });

    batch.set(
      userRef.collection('usageTime').doc('current'),
      {'remainingSeconds': 600, 'dailyAdWatchCount': 0, 'lastAdResetDate': now},
    );

    batch.set(
      userRef.collection('subscription').doc('current'),
      {
        'status': 'none',
        'platform': null,
        'productId': null,
        'originalTransactionId': null,
        'purchaseToken': null,
        'startedAt': null,
        'expiresAt': null,
        'renewedAt': null,
        'cancelledAt': null,
        'autoRenewing': false,
        'verifiedAt': null,
      },
    );

    await batch.commit();
  }

  String _identifier(KakaoLoginResult result) {
    final email = result.email;
    return (email != null && email.isNotEmpty)
        ? email
        : result.kakaoUserId.toString();
  }
}
