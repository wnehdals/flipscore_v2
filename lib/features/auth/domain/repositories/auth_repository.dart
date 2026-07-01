import '../models/app_user.dart';

abstract interface class AuthRepository {
  Stream<AppUser?> get authStateChanges;
  AppUser? get currentUser;
  Future<AppUser> signInWithKakao();
  Future<void> signOut();
  Future<void> deleteAccount();
  Future<void> completeOnboarding();
}
