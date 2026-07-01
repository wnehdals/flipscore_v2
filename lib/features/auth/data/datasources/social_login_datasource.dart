import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart' as kakao;

class KakaoLoginResult {
  const KakaoLoginResult({
    required this.kakaoUserId,
    this.email,
    this.displayName,
    this.photoUrl,
  });

  final int kakaoUserId;
  final String? email;
  final String? displayName;
  final String? photoUrl;
}

abstract interface class SocialLoginDataSource {
  /// 앱 시작 시 기존 Kakao 세션 복원. 토큰 없거나 만료 시 null 반환.
  Future<KakaoLoginResult?> tryRestoreSession();
  Future<KakaoLoginResult> getKakaoUser();
  Future<void> signOut();
}

class SocialLoginDataSourceImpl implements SocialLoginDataSource {
  @override
  Future<KakaoLoginResult?> tryRestoreSession() async {
    try {
      final hasToken = await kakao.AuthApi.instance.hasToken();
      if (!hasToken) return null;
      return await _fetchKakaoUser();
    } catch (_) {
      return null;
    }
  }

  @override
  Future<KakaoLoginResult> getKakaoUser() async {
    if (await kakao.isKakaoTalkInstalled()) {
      await kakao.UserApi.instance.loginWithKakaoTalk();
    } else {
      await kakao.UserApi.instance.loginWithKakaoAccount();
    }
    return _fetchKakaoUser();
  }

  Future<KakaoLoginResult> _fetchKakaoUser() async {
    final kakaoUser = await kakao.UserApi.instance.me();
    return KakaoLoginResult(
      kakaoUserId: kakaoUser.id,
      email: kakaoUser.kakaoAccount?.email,
      displayName: kakaoUser.kakaoAccount?.profile?.nickname,
      photoUrl: kakaoUser.kakaoAccount?.profile?.profileImageUrl,
    );
  }

  @override
  Future<void> signOut() async {
    try {
      await kakao.UserApi.instance.logout();
    } catch (_) {}
  }
}
