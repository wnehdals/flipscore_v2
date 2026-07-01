// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SubscriptionImpl _$$SubscriptionImplFromJson(Map<String, dynamic> json) =>
    _$SubscriptionImpl(
      status: $enumDecode(_$SubscriptionStatusEnumMap, json['status']),
      platform: json['platform'] as String?,
      productId: json['productId'] as String?,
      originalTransactionId: json['originalTransactionId'] as String?,
      purchaseToken: json['purchaseToken'] as String?,
      startedAt: json['startedAt'] == null
          ? null
          : DateTime.parse(json['startedAt'] as String),
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
      renewedAt: json['renewedAt'] == null
          ? null
          : DateTime.parse(json['renewedAt'] as String),
      cancelledAt: json['cancelledAt'] == null
          ? null
          : DateTime.parse(json['cancelledAt'] as String),
      autoRenewing: json['autoRenewing'] as bool? ?? false,
      verifiedAt: json['verifiedAt'] == null
          ? null
          : DateTime.parse(json['verifiedAt'] as String),
    );

Map<String, dynamic> _$$SubscriptionImplToJson(_$SubscriptionImpl instance) =>
    <String, dynamic>{
      'status': _$SubscriptionStatusEnumMap[instance.status]!,
      'platform': instance.platform,
      'productId': instance.productId,
      'originalTransactionId': instance.originalTransactionId,
      'purchaseToken': instance.purchaseToken,
      'startedAt': instance.startedAt?.toIso8601String(),
      'expiresAt': instance.expiresAt?.toIso8601String(),
      'renewedAt': instance.renewedAt?.toIso8601String(),
      'cancelledAt': instance.cancelledAt?.toIso8601String(),
      'autoRenewing': instance.autoRenewing,
      'verifiedAt': instance.verifiedAt?.toIso8601String(),
    };

const _$SubscriptionStatusEnumMap = {
  SubscriptionStatus.none: 'none',
  SubscriptionStatus.active: 'active',
  SubscriptionStatus.expired: 'expired',
  SubscriptionStatus.cancelled: 'cancelled',
};
