// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'usage_time.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UsageTime _$UsageTimeFromJson(Map<String, dynamic> json) {
  return _UsageTime.fromJson(json);
}

/// @nodoc
mixin _$UsageTime {
  String get userId => throw _privateConstructorUsedError;
  int get remainingSeconds => throw _privateConstructorUsedError;
  int get adsWatchedToday => throw _privateConstructorUsedError;
  DateTime get lastAdDate => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this UsageTime to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UsageTime
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UsageTimeCopyWith<UsageTime> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UsageTimeCopyWith<$Res> {
  factory $UsageTimeCopyWith(UsageTime value, $Res Function(UsageTime) then) =
      _$UsageTimeCopyWithImpl<$Res, UsageTime>;
  @useResult
  $Res call({
    String userId,
    int remainingSeconds,
    int adsWatchedToday,
    DateTime lastAdDate,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$UsageTimeCopyWithImpl<$Res, $Val extends UsageTime>
    implements $UsageTimeCopyWith<$Res> {
  _$UsageTimeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UsageTime
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? remainingSeconds = null,
    Object? adsWatchedToday = null,
    Object? lastAdDate = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            remainingSeconds: null == remainingSeconds
                ? _value.remainingSeconds
                : remainingSeconds // ignore: cast_nullable_to_non_nullable
                      as int,
            adsWatchedToday: null == adsWatchedToday
                ? _value.adsWatchedToday
                : adsWatchedToday // ignore: cast_nullable_to_non_nullable
                      as int,
            lastAdDate: null == lastAdDate
                ? _value.lastAdDate
                : lastAdDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UsageTimeImplCopyWith<$Res>
    implements $UsageTimeCopyWith<$Res> {
  factory _$$UsageTimeImplCopyWith(
    _$UsageTimeImpl value,
    $Res Function(_$UsageTimeImpl) then,
  ) = __$$UsageTimeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String userId,
    int remainingSeconds,
    int adsWatchedToday,
    DateTime lastAdDate,
    DateTime updatedAt,
  });
}

/// @nodoc
class __$$UsageTimeImplCopyWithImpl<$Res>
    extends _$UsageTimeCopyWithImpl<$Res, _$UsageTimeImpl>
    implements _$$UsageTimeImplCopyWith<$Res> {
  __$$UsageTimeImplCopyWithImpl(
    _$UsageTimeImpl _value,
    $Res Function(_$UsageTimeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UsageTime
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? remainingSeconds = null,
    Object? adsWatchedToday = null,
    Object? lastAdDate = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$UsageTimeImpl(
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        remainingSeconds: null == remainingSeconds
            ? _value.remainingSeconds
            : remainingSeconds // ignore: cast_nullable_to_non_nullable
                  as int,
        adsWatchedToday: null == adsWatchedToday
            ? _value.adsWatchedToday
            : adsWatchedToday // ignore: cast_nullable_to_non_nullable
                  as int,
        lastAdDate: null == lastAdDate
            ? _value.lastAdDate
            : lastAdDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UsageTimeImpl implements _UsageTime {
  const _$UsageTimeImpl({
    required this.userId,
    required this.remainingSeconds,
    required this.adsWatchedToday,
    required this.lastAdDate,
    required this.updatedAt,
  });

  factory _$UsageTimeImpl.fromJson(Map<String, dynamic> json) =>
      _$$UsageTimeImplFromJson(json);

  @override
  final String userId;
  @override
  final int remainingSeconds;
  @override
  final int adsWatchedToday;
  @override
  final DateTime lastAdDate;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'UsageTime(userId: $userId, remainingSeconds: $remainingSeconds, adsWatchedToday: $adsWatchedToday, lastAdDate: $lastAdDate, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UsageTimeImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.remainingSeconds, remainingSeconds) ||
                other.remainingSeconds == remainingSeconds) &&
            (identical(other.adsWatchedToday, adsWatchedToday) ||
                other.adsWatchedToday == adsWatchedToday) &&
            (identical(other.lastAdDate, lastAdDate) ||
                other.lastAdDate == lastAdDate) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    userId,
    remainingSeconds,
    adsWatchedToday,
    lastAdDate,
    updatedAt,
  );

  /// Create a copy of UsageTime
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UsageTimeImplCopyWith<_$UsageTimeImpl> get copyWith =>
      __$$UsageTimeImplCopyWithImpl<_$UsageTimeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UsageTimeImplToJson(this);
  }
}

abstract class _UsageTime implements UsageTime {
  const factory _UsageTime({
    required final String userId,
    required final int remainingSeconds,
    required final int adsWatchedToday,
    required final DateTime lastAdDate,
    required final DateTime updatedAt,
  }) = _$UsageTimeImpl;

  factory _UsageTime.fromJson(Map<String, dynamic> json) =
      _$UsageTimeImpl.fromJson;

  @override
  String get userId;
  @override
  int get remainingSeconds;
  @override
  int get adsWatchedToday;
  @override
  DateTime get lastAdDate;
  @override
  DateTime get updatedAt;

  /// Create a copy of UsageTime
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UsageTimeImplCopyWith<_$UsageTimeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
