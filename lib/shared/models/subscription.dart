import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums.dart';

part 'subscription.freezed.dart';
part 'subscription.g.dart';

@freezed
abstract class Subscription with _$Subscription {
  const Subscription._();

  const factory Subscription({
    required SubscriptionStatus status,
    String? platform,
    String? productId,
    String? originalTransactionId,
    String? purchaseToken,
    DateTime? startedAt,
    DateTime? expiresAt,
    DateTime? renewedAt,
    DateTime? cancelledAt,
    @Default(false) bool autoRenewing,
    DateTime? verifiedAt,
  }) = _Subscription;

  factory Subscription.initial() => const Subscription(
        status: SubscriptionStatus.none,
      );

  factory Subscription.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionFromJson(json);

  bool get isActive =>
      status == SubscriptionStatus.active &&
      expiresAt != null &&
      expiresAt!.isAfter(DateTime.now());
}
