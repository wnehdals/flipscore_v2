// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'score_viewer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ScoreViewer _$ScoreViewerFromJson(Map<String, dynamic> json) {
  return _ScoreViewer.fromJson(json);
}

/// @nodoc
mixin _$ScoreViewer {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  TransitionMode get transitionMode => throw _privateConstructorUsedError;
  List<ScorePage> get pages => throw _privateConstructorUsedError;
  String? get songId => throw _privateConstructorUsedError;
  String? get songTitle => throw _privateConstructorUsedError;
  GestureType? get gestureType => throw _privateConstructorUsedError;
  bool get hasTimeline => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this ScoreViewer to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ScoreViewer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScoreViewerCopyWith<ScoreViewer> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScoreViewerCopyWith<$Res> {
  factory $ScoreViewerCopyWith(
    ScoreViewer value,
    $Res Function(ScoreViewer) then,
  ) = _$ScoreViewerCopyWithImpl<$Res, ScoreViewer>;
  @useResult
  $Res call({
    String id,
    String title,
    TransitionMode transitionMode,
    List<ScorePage> pages,
    String? songId,
    String? songTitle,
    GestureType? gestureType,
    bool hasTimeline,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$ScoreViewerCopyWithImpl<$Res, $Val extends ScoreViewer>
    implements $ScoreViewerCopyWith<$Res> {
  _$ScoreViewerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ScoreViewer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? transitionMode = null,
    Object? pages = null,
    Object? songId = freezed,
    Object? songTitle = freezed,
    Object? gestureType = freezed,
    Object? hasTimeline = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            transitionMode: null == transitionMode
                ? _value.transitionMode
                : transitionMode // ignore: cast_nullable_to_non_nullable
                      as TransitionMode,
            pages: null == pages
                ? _value.pages
                : pages // ignore: cast_nullable_to_non_nullable
                      as List<ScorePage>,
            songId: freezed == songId
                ? _value.songId
                : songId // ignore: cast_nullable_to_non_nullable
                      as String?,
            songTitle: freezed == songTitle
                ? _value.songTitle
                : songTitle // ignore: cast_nullable_to_non_nullable
                      as String?,
            gestureType: freezed == gestureType
                ? _value.gestureType
                : gestureType // ignore: cast_nullable_to_non_nullable
                      as GestureType?,
            hasTimeline: null == hasTimeline
                ? _value.hasTimeline
                : hasTimeline // ignore: cast_nullable_to_non_nullable
                      as bool,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
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
abstract class _$$ScoreViewerImplCopyWith<$Res>
    implements $ScoreViewerCopyWith<$Res> {
  factory _$$ScoreViewerImplCopyWith(
    _$ScoreViewerImpl value,
    $Res Function(_$ScoreViewerImpl) then,
  ) = __$$ScoreViewerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    TransitionMode transitionMode,
    List<ScorePage> pages,
    String? songId,
    String? songTitle,
    GestureType? gestureType,
    bool hasTimeline,
    DateTime createdAt,
    DateTime updatedAt,
  });
}

/// @nodoc
class __$$ScoreViewerImplCopyWithImpl<$Res>
    extends _$ScoreViewerCopyWithImpl<$Res, _$ScoreViewerImpl>
    implements _$$ScoreViewerImplCopyWith<$Res> {
  __$$ScoreViewerImplCopyWithImpl(
    _$ScoreViewerImpl _value,
    $Res Function(_$ScoreViewerImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ScoreViewer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? transitionMode = null,
    Object? pages = null,
    Object? songId = freezed,
    Object? songTitle = freezed,
    Object? gestureType = freezed,
    Object? hasTimeline = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$ScoreViewerImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        transitionMode: null == transitionMode
            ? _value.transitionMode
            : transitionMode // ignore: cast_nullable_to_non_nullable
                  as TransitionMode,
        pages: null == pages
            ? _value._pages
            : pages // ignore: cast_nullable_to_non_nullable
                  as List<ScorePage>,
        songId: freezed == songId
            ? _value.songId
            : songId // ignore: cast_nullable_to_non_nullable
                  as String?,
        songTitle: freezed == songTitle
            ? _value.songTitle
            : songTitle // ignore: cast_nullable_to_non_nullable
                  as String?,
        gestureType: freezed == gestureType
            ? _value.gestureType
            : gestureType // ignore: cast_nullable_to_non_nullable
                  as GestureType?,
        hasTimeline: null == hasTimeline
            ? _value.hasTimeline
            : hasTimeline // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
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
class _$ScoreViewerImpl implements _ScoreViewer {
  const _$ScoreViewerImpl({
    required this.id,
    required this.title,
    required this.transitionMode,
    required final List<ScorePage> pages,
    this.songId,
    this.songTitle,
    this.gestureType,
    this.hasTimeline = false,
    required this.createdAt,
    required this.updatedAt,
  }) : _pages = pages;

  factory _$ScoreViewerImpl.fromJson(Map<String, dynamic> json) =>
      _$$ScoreViewerImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final TransitionMode transitionMode;
  final List<ScorePage> _pages;
  @override
  List<ScorePage> get pages {
    if (_pages is EqualUnmodifiableListView) return _pages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pages);
  }

  @override
  final String? songId;
  @override
  final String? songTitle;
  @override
  final GestureType? gestureType;
  @override
  @JsonKey()
  final bool hasTimeline;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'ScoreViewer(id: $id, title: $title, transitionMode: $transitionMode, pages: $pages, songId: $songId, songTitle: $songTitle, gestureType: $gestureType, hasTimeline: $hasTimeline, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScoreViewerImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.transitionMode, transitionMode) ||
                other.transitionMode == transitionMode) &&
            const DeepCollectionEquality().equals(other._pages, _pages) &&
            (identical(other.songId, songId) || other.songId == songId) &&
            (identical(other.songTitle, songTitle) ||
                other.songTitle == songTitle) &&
            (identical(other.gestureType, gestureType) ||
                other.gestureType == gestureType) &&
            (identical(other.hasTimeline, hasTimeline) ||
                other.hasTimeline == hasTimeline) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    transitionMode,
    const DeepCollectionEquality().hash(_pages),
    songId,
    songTitle,
    gestureType,
    hasTimeline,
    createdAt,
    updatedAt,
  );

  /// Create a copy of ScoreViewer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScoreViewerImplCopyWith<_$ScoreViewerImpl> get copyWith =>
      __$$ScoreViewerImplCopyWithImpl<_$ScoreViewerImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ScoreViewerImplToJson(this);
  }
}

abstract class _ScoreViewer implements ScoreViewer {
  const factory _ScoreViewer({
    required final String id,
    required final String title,
    required final TransitionMode transitionMode,
    required final List<ScorePage> pages,
    final String? songId,
    final String? songTitle,
    final GestureType? gestureType,
    final bool hasTimeline,
    required final DateTime createdAt,
    required final DateTime updatedAt,
  }) = _$ScoreViewerImpl;

  factory _ScoreViewer.fromJson(Map<String, dynamic> json) =
      _$ScoreViewerImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  TransitionMode get transitionMode;
  @override
  List<ScorePage> get pages;
  @override
  String? get songId;
  @override
  String? get songTitle;
  @override
  GestureType? get gestureType;
  @override
  bool get hasTimeline;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;

  /// Create a copy of ScoreViewer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScoreViewerImplCopyWith<_$ScoreViewerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ScorePage _$ScorePageFromJson(Map<String, dynamic> json) {
  return _ScorePage.fromJson(json);
}

/// @nodoc
mixin _$ScorePage {
  String get id => throw _privateConstructorUsedError;
  int get order => throw _privateConstructorUsedError;
  ScoreType get type => throw _privateConstructorUsedError;
  String get localPath => throw _privateConstructorUsedError;
  String? get storagePath => throw _privateConstructorUsedError;

  /// Serializes this ScorePage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ScorePage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScorePageCopyWith<ScorePage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScorePageCopyWith<$Res> {
  factory $ScorePageCopyWith(ScorePage value, $Res Function(ScorePage) then) =
      _$ScorePageCopyWithImpl<$Res, ScorePage>;
  @useResult
  $Res call({
    String id,
    int order,
    ScoreType type,
    String localPath,
    String? storagePath,
  });
}

/// @nodoc
class _$ScorePageCopyWithImpl<$Res, $Val extends ScorePage>
    implements $ScorePageCopyWith<$Res> {
  _$ScorePageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ScorePage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? order = null,
    Object? type = null,
    Object? localPath = null,
    Object? storagePath = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            order: null == order
                ? _value.order
                : order // ignore: cast_nullable_to_non_nullable
                      as int,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as ScoreType,
            localPath: null == localPath
                ? _value.localPath
                : localPath // ignore: cast_nullable_to_non_nullable
                      as String,
            storagePath: freezed == storagePath
                ? _value.storagePath
                : storagePath // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ScorePageImplCopyWith<$Res>
    implements $ScorePageCopyWith<$Res> {
  factory _$$ScorePageImplCopyWith(
    _$ScorePageImpl value,
    $Res Function(_$ScorePageImpl) then,
  ) = __$$ScorePageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    int order,
    ScoreType type,
    String localPath,
    String? storagePath,
  });
}

/// @nodoc
class __$$ScorePageImplCopyWithImpl<$Res>
    extends _$ScorePageCopyWithImpl<$Res, _$ScorePageImpl>
    implements _$$ScorePageImplCopyWith<$Res> {
  __$$ScorePageImplCopyWithImpl(
    _$ScorePageImpl _value,
    $Res Function(_$ScorePageImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ScorePage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? order = null,
    Object? type = null,
    Object? localPath = null,
    Object? storagePath = freezed,
  }) {
    return _then(
      _$ScorePageImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        order: null == order
            ? _value.order
            : order // ignore: cast_nullable_to_non_nullable
                  as int,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as ScoreType,
        localPath: null == localPath
            ? _value.localPath
            : localPath // ignore: cast_nullable_to_non_nullable
                  as String,
        storagePath: freezed == storagePath
            ? _value.storagePath
            : storagePath // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ScorePageImpl implements _ScorePage {
  const _$ScorePageImpl({
    required this.id,
    required this.order,
    required this.type,
    required this.localPath,
    this.storagePath,
  });

  factory _$ScorePageImpl.fromJson(Map<String, dynamic> json) =>
      _$$ScorePageImplFromJson(json);

  @override
  final String id;
  @override
  final int order;
  @override
  final ScoreType type;
  @override
  final String localPath;
  @override
  final String? storagePath;

  @override
  String toString() {
    return 'ScorePage(id: $id, order: $order, type: $type, localPath: $localPath, storagePath: $storagePath)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScorePageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.order, order) || other.order == order) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.localPath, localPath) ||
                other.localPath == localPath) &&
            (identical(other.storagePath, storagePath) ||
                other.storagePath == storagePath));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, order, type, localPath, storagePath);

  /// Create a copy of ScorePage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScorePageImplCopyWith<_$ScorePageImpl> get copyWith =>
      __$$ScorePageImplCopyWithImpl<_$ScorePageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ScorePageImplToJson(this);
  }
}

abstract class _ScorePage implements ScorePage {
  const factory _ScorePage({
    required final String id,
    required final int order,
    required final ScoreType type,
    required final String localPath,
    final String? storagePath,
  }) = _$ScorePageImpl;

  factory _ScorePage.fromJson(Map<String, dynamic> json) =
      _$ScorePageImpl.fromJson;

  @override
  String get id;
  @override
  int get order;
  @override
  ScoreType get type;
  @override
  String get localPath;
  @override
  String? get storagePath;

  /// Create a copy of ScorePage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScorePageImplCopyWith<_$ScorePageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
