// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaymentImpl _$$PaymentImplFromJson(Map<String, dynamic> json) =>
    _$PaymentImpl(
      transactionId: json['transactionId'] as String,
      productId: json['productId'] as String,
      platform: json['platform'] as String,
      purchaseToken: json['purchaseToken'] as String?,
      receiptData: json['receiptData'] as String?,
      verificationStatus: $enumDecode(
        _$VerificationStatusEnumMap,
        json['verificationStatus'],
      ),
      type: json['type'] as String? ?? 'subscription',
      createdAt: DateTime.parse(json['createdAt'] as String),
      verifiedAt: json['verifiedAt'] == null
          ? null
          : DateTime.parse(json['verifiedAt'] as String),
    );

Map<String, dynamic> _$$PaymentImplToJson(_$PaymentImpl instance) =>
    <String, dynamic>{
      'transactionId': instance.transactionId,
      'productId': instance.productId,
      'platform': instance.platform,
      'purchaseToken': instance.purchaseToken,
      'receiptData': instance.receiptData,
      'verificationStatus':
          _$VerificationStatusEnumMap[instance.verificationStatus]!,
      'type': instance.type,
      'createdAt': instance.createdAt.toIso8601String(),
      'verifiedAt': instance.verifiedAt?.toIso8601String(),
    };

const _$VerificationStatusEnumMap = {
  VerificationStatus.pending: 'pending',
  VerificationStatus.verified: 'verified',
  VerificationStatus.invalid: 'invalid',
};
