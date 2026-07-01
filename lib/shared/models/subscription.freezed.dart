// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subscription.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Subscription _$SubscriptionFromJson(Map<String, dynamic> json) {
  return _Subscription.fromJson(json);
}

/// @nodoc
mixin _$Subscription {
  SubscriptionStatus get status => throw _privateConstructorUsedError;
  String? get platform => throw _privateConstructorUsedError;
  String? get productId => throw _privateConstructorUsedError;
  String? get originalTransactionId => throw _privateConstructorUsedError;
  String? get purchaseToken => throw _privateConstructorUsedError;
  DateTime? get startedAt => throw _privateConstructorUsedError;
  DateTime? get expiresAt => throw _privateConstructorUsedError;
  DateTime? get renewedAt => throw _privateConstructorUsedError;
  DateTime? get cancelledAt => throw _privateConstructorUsedError;
  bool get autoRenewing => throw _privateConstructorUsedError;
  DateTime? get verifiedAt => throw _privateConstructorUsedError;

  /// Serializes this Subscription to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Subscription
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SubscriptionCopyWith<Subscription> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubscriptionCopyWith<$Res> {
  factory $SubscriptionCopyWith(
    Subscription value,
    $Res Function(Subscription) then,
  ) = _$SubscriptionCopyWithImpl<$Res, Subscription>;
  @useResult
  $Res call({
    SubscriptionStatus status,
    String? platform,
    String? productId,
    String? originalTransactionId,
    String? purchaseToken,
    DateTime? startedAt,
    DateTime? expiresAt,
    DateTime? renewedAt,
    DateTime? cancelledAt,
    bool autoRenewing,
    DateTime? verifiedAt,
  });
}

/// @nodoc
class _$SubscriptionCopyWithImpl<$Res, $Val extends Subscription>
    implements $SubscriptionCopyWith<$Res> {
  _$SubscriptionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Subscription
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? platform = freezed,
    Object? productId = freezed,
    Object? originalTransactionId = freezed,
    Object? purchaseToken = freezed,
    Object? startedAt = freezed,
    Object? expiresAt = freezed,
    Object? renewedAt = freezed,
    Object? cancelledAt = freezed,
    Object? autoRenewing = null,
    Object? verifiedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as SubscriptionStatus,
            platform: freezed == platform
                ? _value.platform
                : platform // ignore: cast_nullable_to_non_nullable
                      as String?,
            productId: freezed == productId
                ? _value.productId
                : productId // ignore: cast_nullable_to_non_nullable
                      as String?,
            originalTransactionId: freezed == originalTransactionId
                ? _value.originalTransactionId
                : originalTransactionId // ignore: cast_nullable_to_non_nullable
                      as String?,
            purchaseToken: freezed == purchaseToken
                ? _value.purchaseToken
                : purchaseToken // ignore: cast_nullable_to_non_nullable
                      as String?,
            startedAt: freezed == startedAt
                ? _value.startedAt
                : startedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            expiresAt: freezed == expiresAt
                ? _value.expiresAt
                : expiresAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            renewedAt: freezed == renewedAt
                ? _value.renewedAt
                : renewedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            cancelledAt: freezed == cancelledAt
                ? _value.cancelledAt
                : cancelledAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            autoRenewing: null == autoRenewing
                ? _value.autoRenewing
                : autoRenewing // ignore: cast_nullable_to_non_nullable
                      as bool,
            verifiedAt: freezed == verifiedAt
                ? _value.verifiedAt
                : verifiedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SubscriptionImplCopyWith<$Res>
    implements $SubscriptionCopyWith<$Res> {
  factory _$$SubscriptionImplCopyWith(
    _$SubscriptionImpl value,
    $Res Function(_$SubscriptionImpl) then,
  ) = __$$SubscriptionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    SubscriptionStatus status,
    String? platform,
    String? productId,
    String? originalTransactionId,
    String? purchaseToken,
    DateTime? startedAt,
    DateTime? expiresAt,
    DateTime? renewedAt,
    DateTime? cancelledAt,
    bool autoRenewing,
    DateTime? verifiedAt,
  });
}

/// @nodoc
class __$$SubscriptionImplCopyWithImpl<$Res>
    extends _$SubscriptionCopyWithImpl<$Res, _$SubscriptionImpl>
    implements _$$SubscriptionImplCopyWith<$Res> {
  __$$SubscriptionImplCopyWithImpl(
    _$SubscriptionImpl _value,
    $Res Function(_$SubscriptionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Subscription
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
    Object? platform = freezed,
    Object? productId = freezed,
    Object? originalTransactionId = freezed,
    Object? purchaseToken = freezed,
    Object? startedAt = freezed,
    Object? expiresAt = freezed,
    Object? renewedAt = freezed,
    Object? cancelledAt = freezed,
    Object? autoRenewing = null,
    Object? verifiedAt = freezed,
  }) {
    return _then(
      _$SubscriptionImpl(
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as SubscriptionStatus,
        platform: freezed == platform
            ? _value.platform
            : platform // ignore: cast_nullable_to_non_nullable
                  as String?,
        productId: freezed == productId
            ? _value.productId
            : productId // ignore: cast_nullable_to_non_nullable
                  as String?,
        originalTransactionId: freezed == originalTransactionId
            ? _value.originalTransactionId
            : originalTransactionId // ignore: cast_nullable_to_non_nullable
                  as String?,
        purchaseToken: freezed == purchaseToken
            ? _value.purchaseToken
            : purchaseToken // ignore: cast_nullable_to_non_nullable
                  as String?,
        startedAt: freezed == startedAt
            ? _value.startedAt
            : startedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        expiresAt: freezed == expiresAt
            ? _value.expiresAt
            : expiresAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        renewedAt: freezed == renewedAt
            ? _value.renewedAt
            : renewedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        cancelledAt: freezed == cancelledAt
            ? _value.cancelledAt
            : cancelledAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        autoRenewing: null == autoRenewing
            ? _value.autoRenewing
            : autoRenewing // ignore: cast_nullable_to_non_nullable
                  as bool,
        verifiedAt: freezed == verifiedAt
            ? _value.verifiedAt
            : verifiedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SubscriptionImpl extends _Subscription {
  const _$SubscriptionImpl({
    required this.status,
    this.platform,
    this.productId,
    this.originalTransactionId,
    this.purchaseToken,
    this.startedAt,
    this.expiresAt,
    this.renewedAt,
    this.cancelledAt,
    this.autoRenewing = false,
    this.verifiedAt,
  }) : super._();

  factory _$SubscriptionImpl.fromJson(Map<String, dynamic> json) =>
      _$$SubscriptionImplFromJson(json);

  @override
  final SubscriptionStatus status;
  @override
  final String? platform;
  @override
  final String? productId;
  @override
  final String? originalTransactionId;
  @override
  final String? purchaseToken;
  @override
  final DateTime? startedAt;
  @override
  final DateTime? expiresAt;
  @override
  final DateTime? renewedAt;
  @override
  final DateTime? cancelledAt;
  @override
  @JsonKey()
  final bool autoRenewing;
  @override
  final DateTime? verifiedAt;

  @override
  String toString() {
    return 'Subscription(status: $status, platform: $platform, productId: $productId, originalTransactionId: $originalTransactionId, purchaseToken: $purchaseToken, startedAt: $startedAt, expiresAt: $expiresAt, renewedAt: $renewedAt, cancelledAt: $cancelledAt, autoRenewing: $autoRenewing, verifiedAt: $verifiedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubscriptionImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.platform, platform) ||
                other.platform == platform) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.originalTransactionId, originalTransactionId) ||
                other.originalTransactionId == originalTransactionId) &&
            (identical(other.purchaseToken, purchaseToken) ||
                other.purchaseToken == purchaseToken) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.renewedAt, renewedAt) ||
                other.renewedAt == renewedAt) &&
            (identical(other.cancelledAt, cancelledAt) ||
                other.cancelledAt == cancelledAt) &&
            (identical(other.autoRenewing, autoRenewing) ||
                other.autoRenewing == autoRenewing) &&
            (identical(other.verifiedAt, verifiedAt) ||
                other.verifiedAt == verifiedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    status,
    platform,
    productId,
    originalTransactionId,
    purchaseToken,
    startedAt,
    expiresAt,
    renewedAt,
    cancelledAt,
    autoRenewing,
    verifiedAt,
  );

  /// Create a copy of Subscription
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SubscriptionImplCopyWith<_$SubscriptionImpl> get copyWith =>
      __$$SubscriptionImplCopyWithImpl<_$SubscriptionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SubscriptionImplToJson(this);
  }
}

abstract class _Subscription extends Subscription {
  const factory _Subscription({
    required final SubscriptionStatus status,
    final String? platform,
    final String? productId,
    final String? originalTransactionId,
    final String? purchaseToken,
    final DateTime? startedAt,
    final DateTime? expiresAt,
    final DateTime? renewedAt,
    final DateTime? cancelledAt,
    final bool autoRenewing,
    final DateTime? verifiedAt,
  }) = _$SubscriptionImpl;
  const _Subscription._() : super._();

  factory _Subscription.fromJson(Map<String, dynamic> json) =
      _$SubscriptionImpl.fromJson;

  @override
  SubscriptionStatus get status;
  @override
  String? get platform;
  @override
  String? get productId;
  @override
  String? get originalTransactionId;
  @override
  String? get purchaseToken;
  @override
  DateTime? get startedAt;
  @override
  DateTime? get expiresAt;
  @override
  DateTime? get renewedAt;
  @override
  DateTime? get cancelledAt;
  @override
  bool get autoRenewing;
  @override
  DateTime? get verifiedAt;

  /// Create a copy of Subscription
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SubscriptionImplCopyWith<_$SubscriptionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
