// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'score_viewer_timeline.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ScoreViewerTimeline _$ScoreViewerTimelineFromJson(Map<String, dynamic> json) {
  return _ScoreViewerTimeline.fromJson(json);
}

/// @nodoc
mixin _$ScoreViewerTimeline {
  String get id => throw _privateConstructorUsedError;
  String get scoreViewerId => throw _privateConstructorUsedError;
  List<TimelineEntry> get entries => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this ScoreViewerTimeline to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ScoreViewerTimeline
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScoreViewerTimelineCopyWith<ScoreViewerTimeline> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScoreViewerTimelineCopyWith<$Res> {
  factory $ScoreViewerTimelineCopyWith(
    ScoreViewerTimeline value,
    $Res Function(ScoreViewerTimeline) then,
  ) = _$ScoreViewerTimelineCopyWithImpl<$Res, ScoreViewerTimeline>;
  @useResult
  $Res call({
    String id,
    String scoreViewerId,
    List<TimelineEntry> entries,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$ScoreViewerTimelineCopyWithImpl<$Res, $Val extends ScoreViewerTimeline>
    implements $ScoreViewerTimelineCopyWith<$Res> {
  _$ScoreViewerTimelineCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ScoreViewerTimeline
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? scoreViewerId = null,
    Object? entries = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            scoreViewerId: null == scoreViewerId
                ? _value.scoreViewerId
                : scoreViewerId // ignore: cast_nullable_to_non_nullable
                      as String,
            entries: null == entries
                ? _value.entries
                : entries // ignore: cast_nullable_to_non_nullable
                      as List<TimelineEntry>,
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
abstract class _$$ScoreViewerTimelineImplCopyWith<$Res>
    implements $ScoreViewerTimelineCopyWith<$Res> {
  factory _$$ScoreViewerTimelineImplCopyWith(
    _$ScoreViewerTimelineImpl value,
    $Res Function(_$ScoreViewerTimelineImpl) then,
  ) = __$$ScoreViewerTimelineImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String scoreViewerId,
    List<TimelineEntry> entries,
    DateTime updatedAt,
  });
}

/// @nodoc
class __$$ScoreViewerTimelineImplCopyWithImpl<$Res>
    extends _$ScoreViewerTimelineCopyWithImpl<$Res, _$ScoreViewerTimelineImpl>
    implements _$$ScoreViewerTimelineImplCopyWith<$Res> {
  __$$ScoreViewerTimelineImplCopyWithImpl(
    _$ScoreViewerTimelineImpl _value,
    $Res Function(_$ScoreViewerTimelineImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ScoreViewerTimeline
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? scoreViewerId = null,
    Object? entries = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$ScoreViewerTimelineImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        scoreViewerId: null == scoreViewerId
            ? _value.scoreViewerId
            : scoreViewerId // ignore: cast_nullable_to_non_nullable
                  as String,
        entries: null == entries
            ? _value._entries
            : entries // ignore: cast_nullable_to_non_nullable
                  as List<TimelineEntry>,
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
class _$ScoreViewerTimelineImpl implements _ScoreViewerTimeline {
  const _$ScoreViewerTimelineImpl({
    required this.id,
    required this.scoreViewerId,
    required final List<TimelineEntry> entries,
    required this.updatedAt,
  }) : _entries = entries;

  factory _$ScoreViewerTimelineImpl.fromJson(Map<String, dynamic> json) =>
      _$$ScoreViewerTimelineImplFromJson(json);

  @override
  final String id;
  @override
  final String scoreViewerId;
  final List<TimelineEntry> _entries;
  @override
  List<TimelineEntry> get entries {
    if (_entries is EqualUnmodifiableListView) return _entries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_entries);
  }

  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'ScoreViewerTimeline(id: $id, scoreViewerId: $scoreViewerId, entries: $entries, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScoreViewerTimelineImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.scoreViewerId, scoreViewerId) ||
                other.scoreViewerId == scoreViewerId) &&
            const DeepCollectionEquality().equals(other._entries, _entries) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    scoreViewerId,
    const DeepCollectionEquality().hash(_entries),
    updatedAt,
  );

  /// Create a copy of ScoreViewerTimeline
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScoreViewerTimelineImplCopyWith<_$ScoreViewerTimelineImpl> get copyWith =>
      __$$ScoreViewerTimelineImplCopyWithImpl<_$ScoreViewerTimelineImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ScoreViewerTimelineImplToJson(this);
  }
}

abstract class _ScoreViewerTimeline implements ScoreViewerTimeline {
  const factory _ScoreViewerTimeline({
    required final String id,
    required final String scoreViewerId,
    required final List<TimelineEntry> entries,
    required final DateTime updatedAt,
  }) = _$ScoreViewerTimelineImpl;

  factory _ScoreViewerTimeline.fromJson(Map<String, dynamic> json) =
      _$ScoreViewerTimelineImpl.fromJson;

  @override
  String get id;
  @override
  String get scoreViewerId;
  @override
  List<TimelineEntry> get entries;
  @override
  DateTime get updatedAt;

  /// Create a copy of ScoreViewerTimeline
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScoreViewerTimelineImplCopyWith<_$ScoreViewerTimelineImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TimelineEntry _$TimelineEntryFromJson(Map<String, dynamic> json) {
  return _TimelineEntry.fromJson(json);
}

/// @nodoc
mixin _$TimelineEntry {
  int get pageIndex => throw _privateConstructorUsedError;
  int get timestampMs => throw _privateConstructorUsedError;

  /// Serializes this TimelineEntry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TimelineEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TimelineEntryCopyWith<TimelineEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TimelineEntryCopyWith<$Res> {
  factory $TimelineEntryCopyWith(
    TimelineEntry value,
    $Res Function(TimelineEntry) then,
  ) = _$TimelineEntryCopyWithImpl<$Res, TimelineEntry>;
  @useResult
  $Res call({int pageIndex, int timestampMs});
}

/// @nodoc
class _$TimelineEntryCopyWithImpl<$Res, $Val extends TimelineEntry>
    implements $TimelineEntryCopyWith<$Res> {
  _$TimelineEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TimelineEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? pageIndex = null, Object? timestampMs = null}) {
    return _then(
      _value.copyWith(
            pageIndex: null == pageIndex
                ? _value.pageIndex
                : pageIndex // ignore: cast_nullable_to_non_nullable
                      as int,
            timestampMs: null == timestampMs
                ? _value.timestampMs
                : timestampMs // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TimelineEntryImplCopyWith<$Res>
    implements $TimelineEntryCopyWith<$Res> {
  factory _$$TimelineEntryImplCopyWith(
    _$TimelineEntryImpl value,
    $Res Function(_$TimelineEntryImpl) then,
  ) = __$$TimelineEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int pageIndex, int timestampMs});
}

/// @nodoc
class __$$TimelineEntryImplCopyWithImpl<$Res>
    extends _$TimelineEntryCopyWithImpl<$Res, _$TimelineEntryImpl>
    implements _$$TimelineEntryImplCopyWith<$Res> {
  __$$TimelineEntryImplCopyWithImpl(
    _$TimelineEntryImpl _value,
    $Res Function(_$TimelineEntryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TimelineEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? pageIndex = null, Object? timestampMs = null}) {
    return _then(
      _$TimelineEntryImpl(
        pageIndex: null == pageIndex
            ? _value.pageIndex
            : pageIndex // ignore: cast_nullable_to_non_nullable
                  as int,
        timestampMs: null == timestampMs
            ? _value.timestampMs
            : timestampMs // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TimelineEntryImpl implements _TimelineEntry {
  const _$TimelineEntryImpl({
    required this.pageIndex,
    required this.timestampMs,
  });

  factory _$TimelineEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$TimelineEntryImplFromJson(json);

  @override
  final int pageIndex;
  @override
  final int timestampMs;

  @override
  String toString() {
    return 'TimelineEntry(pageIndex: $pageIndex, timestampMs: $timestampMs)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimelineEntryImpl &&
            (identical(other.pageIndex, pageIndex) ||
                other.pageIndex == pageIndex) &&
            (identical(other.timestampMs, timestampMs) ||
                other.timestampMs == timestampMs));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, pageIndex, timestampMs);

  /// Create a copy of TimelineEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TimelineEntryImplCopyWith<_$TimelineEntryImpl> get copyWith =>
      __$$TimelineEntryImplCopyWithImpl<_$TimelineEntryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TimelineEntryImplToJson(this);
  }
}

abstract class _TimelineEntry implements TimelineEntry {
  const factory _TimelineEntry({
    required final int pageIndex,
    required final int timestampMs,
  }) = _$TimelineEntryImpl;

  factory _TimelineEntry.fromJson(Map<String, dynamic> json) =
      _$TimelineEntryImpl.fromJson;

  @override
  int get pageIndex;
  @override
  int get timestampMs;

  /// Create a copy of TimelineEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TimelineEntryImplCopyWith<_$TimelineEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
