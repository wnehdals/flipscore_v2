import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums.dart';

part 'payment.freezed.dart';
part 'payment.g.dart';

@freezed
abstract class Payment with _$Payment {
  const factory Payment({
    required String transactionId,
    required String productId,
    required String platform,
    String? purchaseToken,
    String? receiptData,
    required VerificationStatus verificationStatus,
    @Default('subscription') String type,
    required DateTime createdAt,
    DateTime? verifiedAt,
  }) = _Payment;

  factory Payment.fromJson(Map<String, dynamic> json) =>
      _$PaymentFromJson(json);
}
