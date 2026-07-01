import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../shared/models/enums.dart';

part 'app_user.freezed.dart';
part 'app_user.g.dart';

@freezed
abstract class AppUser with _$AppUser {
  const factory AppUser({
    required String kakaoId,  // Kakao 유저 ID
    required String docId,    // Firestore 문서 ID: AES256_encrypt("kakao/identifier")
    String? email,
    String? displayName,
    String? photoUrl,
    SocialProvider? provider,
    @Default(true) bool isFirstLogin,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _AppUser;

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);
}
