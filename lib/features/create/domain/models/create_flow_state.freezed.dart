// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_flow_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$CreateFlowState {
  String get title => throw _privateConstructorUsedError;
  ScoreType? get scoreType => throw _privateConstructorUsedError;
  List<String> get scorePaths => throw _privateConstructorUsedError;
  TransitionMode? get transitionMode => throw _privateConstructorUsedError;
  String? get songPath => throw _privateConstructorUsedError;
  String? get songTitle => throw _privateConstructorUsedError;
  GestureType? get gestureType => throw _privateConstructorUsedError;
  List<TimelineEntry> get timelineEntries => throw _privateConstructorUsedError;
  bool get isSaving => throw _privateConstructorUsedError;
  String? get saveError => throw _privateConstructorUsedError;
  ScoreViewer? get editingViewer => throw _privateConstructorUsedError;

  /// Create a copy of CreateFlowState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateFlowStateCopyWith<CreateFlowState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateFlowStateCopyWith<$Res> {
  factory $CreateFlowStateCopyWith(
    CreateFlowState value,
    $Res Function(CreateFlowState) then,
  ) = _$CreateFlowStateCopyWithImpl<$Res, CreateFlowState>;
  @useResult
  $Res call({
    String title,
    ScoreType? scoreType,
    List<String> scorePaths,
    TransitionMode? transitionMode,
    String? songPath,
    String? songTitle,
    GestureType? gestureType,
    List<TimelineEntry> timelineEntries,
    bool isSaving,
    String? saveError,
    ScoreViewer? editingViewer,
  });

  $ScoreViewerCopyWith<$Res>? get editingViewer;
}

/// @nodoc
class _$CreateFlowStateCopyWithImpl<$Res, $Val extends CreateFlowState>
    implements $CreateFlowStateCopyWith<$Res> {
  _$CreateFlowStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateFlowState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? scoreType = freezed,
    Object? scorePaths = null,
    Object? transitionMode = freezed,
    Object? songPath = freezed,
    Object? songTitle = freezed,
    Object? gestureType = freezed,
    Object? timelineEntries = null,
    Object? isSaving = null,
    Object? saveError = freezed,
    Object? editingViewer = freezed,
  }) {
    return _then(
      _value.copyWith(
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            scoreType: freezed == scoreType
                ? _value.scoreType
                : scoreType // ignore: cast_nullable_to_non_nullable
                      as ScoreType?,
            scorePaths: null == scorePaths
                ? _value.scorePaths
                : scorePaths // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            transitionMode: freezed == transitionMode
                ? _value.transitionMode
                : transitionMode // ignore: cast_nullable_to_non_nullable
                      as TransitionMode?,
            songPath: freezed == songPath
                ? _value.songPath
                : songPath // ignore: cast_nullable_to_non_nullable
                      as String?,
            songTitle: freezed == songTitle
                ? _value.songTitle
                : songTitle // ignore: cast_nullable_to_non_nullable
                      as String?,
            gestureType: freezed == gestureType
                ? _value.gestureType
                : gestureType // ignore: cast_nullable_to_non_nullable
                      as GestureType?,
            timelineEntries: null == timelineEntries
                ? _value.timelineEntries
                : timelineEntries // ignore: cast_nullable_to_non_nullable
                      as List<TimelineEntry>,
            isSaving: null == isSaving
                ? _value.isSaving
                : isSaving // ignore: cast_nullable_to_non_nullable
                      as bool,
            saveError: freezed == saveError
                ? _value.saveError
                : saveError // ignore: cast_nullable_to_non_nullable
                      as String?,
            editingViewer: freezed == editingViewer
                ? _value.editingViewer
                : editingViewer // ignore: cast_nullable_to_non_nullable
                      as ScoreViewer?,
          )
          as $Val,
    );
  }

  /// Create a copy of CreateFlowState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ScoreViewerCopyWith<$Res>? get editingViewer {
    if (_value.editingViewer == null) {
      return null;
    }

    return $ScoreViewerCopyWith<$Res>(_value.editingViewer!, (value) {
      return _then(_value.copyWith(editingViewer: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CreateFlowStateImplCopyWith<$Res>
    implements $CreateFlowStateCopyWith<$Res> {
  factory _$$CreateFlowStateImplCopyWith(
    _$CreateFlowStateImpl value,
    $Res Function(_$CreateFlowStateImpl) then,
  ) = __$$CreateFlowStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String title,
    ScoreType? scoreType,
    List<String> scorePaths,
    TransitionMode? transitionMode,
    String? songPath,
    String? songTitle,
    GestureType? gestureType,
    List<TimelineEntry> timelineEntries,
    bool isSaving,
    String? saveError,
    ScoreViewer? editingViewer,
  });

  @override
  $ScoreViewerCopyWith<$Res>? get editingViewer;
}

/// @nodoc
class __$$CreateFlowStateImplCopyWithImpl<$Res>
    extends _$CreateFlowStateCopyWithImpl<$Res, _$CreateFlowStateImpl>
    implements _$$CreateFlowStateImplCopyWith<$Res> {
  __$$CreateFlowStateImplCopyWithImpl(
    _$CreateFlowStateImpl _value,
    $Res Function(_$CreateFlowStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CreateFlowState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? scoreType = freezed,
    Object? scorePaths = null,
    Object? transitionMode = freezed,
    Object? songPath = freezed,
    Object? songTitle = freezed,
    Object? gestureType = freezed,
    Object? timelineEntries = null,
    Object? isSaving = null,
    Object? saveError = freezed,
    Object? editingViewer = freezed,
  }) {
    return _then(
      _$CreateFlowStateImpl(
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        scoreType: freezed == scoreType
            ? _value.scoreType
            : scoreType // ignore: cast_nullable_to_non_nullable
                  as ScoreType?,
        scorePaths: null == scorePaths
            ? _value._scorePaths
            : scorePaths // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        transitionMode: freezed == transitionMode
            ? _value.transitionMode
            : transitionMode // ignore: cast_nullable_to_non_nullable
                  as TransitionMode?,
        songPath: freezed == songPath
            ? _value.songPath
            : songPath // ignore: cast_nullable_to_non_nullable
                  as String?,
        songTitle: freezed == songTitle
            ? _value.songTitle
            : songTitle // ignore: cast_nullable_to_non_nullable
                  as String?,
        gestureType: freezed == gestureType
            ? _value.gestureType
            : gestureType // ignore: cast_nullable_to_non_nullable
                  as GestureType?,
        timelineEntries: null == timelineEntries
            ? _value._timelineEntries
            : timelineEntries // ignore: cast_nullable_to_non_nullable
                  as List<TimelineEntry>,
        isSaving: null == isSaving
            ? _value.isSaving
            : isSaving // ignore: cast_nullable_to_non_nullable
                  as bool,
        saveError: freezed == saveError
            ? _value.saveError
            : saveError // ignore: cast_nullable_to_non_nullable
                  as String?,
        editingViewer: freezed == editingViewer
            ? _value.editingViewer
            : editingViewer // ignore: cast_nullable_to_non_nullable
                  as ScoreViewer?,
      ),
    );
  }
}

/// @nodoc

class _$CreateFlowStateImpl extends _CreateFlowState {
  const _$CreateFlowStateImpl({
    this.title = '',
    this.scoreType,
    final List<String> scorePaths = const [],
    this.transitionMode,
    this.songPath,
    this.songTitle,
    this.gestureType,
    final List<TimelineEntry> timelineEntries = const [],
    this.isSaving = false,
    this.saveError,
    this.editingViewer,
  }) : _scorePaths = scorePaths,
       _timelineEntries = timelineEntries,
       super._();

  @override
  @JsonKey()
  final String title;
  @override
  final ScoreType? scoreType;
  final List<String> _scorePaths;
  @override
  @JsonKey()
  List<String> get scorePaths {
    if (_scorePaths is EqualUnmodifiableListView) return _scorePaths;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_scorePaths);
  }

  @override
  final TransitionMode? transitionMode;
  @override
  final String? songPath;
  @override
  final String? songTitle;
  @override
  final GestureType? gestureType;
  final List<TimelineEntry> _timelineEntries;
  @override
  @JsonKey()
  List<TimelineEntry> get timelineEntries {
    if (_timelineEntries is EqualUnmodifiableListView) return _timelineEntries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_timelineEntries);
  }

  @override
  @JsonKey()
  final bool isSaving;
  @override
  final String? saveError;
  @override
  final ScoreViewer? editingViewer;

  @override
  String toString() {
    return 'CreateFlowState(title: $title, scoreType: $scoreType, scorePaths: $scorePaths, transitionMode: $transitionMode, songPath: $songPath, songTitle: $songTitle, gestureType: $gestureType, timelineEntries: $timelineEntries, isSaving: $isSaving, saveError: $saveError, editingViewer: $editingViewer)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateFlowStateImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.scoreType, scoreType) ||
                other.scoreType == scoreType) &&
            const DeepCollectionEquality().equals(
              other._scorePaths,
              _scorePaths,
            ) &&
            (identical(other.transitionMode, transitionMode) ||
                other.transitionMode == transitionMode) &&
            (identical(other.songPath, songPath) ||
                other.songPath == songPath) &&
            (identical(other.songTitle, songTitle) ||
                other.songTitle == songTitle) &&
            (identical(other.gestureType, gestureType) ||
                other.gestureType == gestureType) &&
            const DeepCollectionEquality().equals(
              other._timelineEntries,
              _timelineEntries,
            ) &&
            (identical(other.isSaving, isSaving) ||
                other.isSaving == isSaving) &&
            (identical(other.saveError, saveError) ||
                other.saveError == saveError) &&
            (identical(other.editingViewer, editingViewer) ||
                other.editingViewer == editingViewer));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    title,
    scoreType,
    const DeepCollectionEquality().hash(_scorePaths),
    transitionMode,
    songPath,
    songTitle,
    gestureType,
    const DeepCollectionEquality().hash(_timelineEntries),
    isSaving,
    saveError,
    editingViewer,
  );

  /// Create a copy of CreateFlowState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateFlowStateImplCopyWith<_$CreateFlowStateImpl> get copyWith =>
      __$$CreateFlowStateImplCopyWithImpl<_$CreateFlowStateImpl>(
        this,
        _$identity,
      );
}

abstract class _CreateFlowState extends CreateFlowState {
  const factory _CreateFlowState({
    final String title,
    final ScoreType? scoreType,
    final List<String> scorePaths,
    final TransitionMode? transitionMode,
    final String? songPath,
    final String? songTitle,
    final GestureType? gestureType,
    final List<TimelineEntry> timelineEntries,
    final bool isSaving,
    final String? saveError,
    final ScoreViewer? editingViewer,
  }) = _$CreateFlowStateImpl;
  const _CreateFlowState._() : super._();

  @override
  String get title;
  @override
  ScoreType? get scoreType;
  @override
  List<String> get scorePaths;
  @override
  TransitionMode? get transitionMode;
  @override
  String? get songPath;
  @override
  String? get songTitle;
  @override
  GestureType? get gestureType;
  @override
  List<TimelineEntry> get timelineEntries;
  @override
  bool get isSaving;
  @override
  String? get saveError;
  @override
  ScoreViewer? get editingViewer;

  /// Create a copy of CreateFlowState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateFlowStateImplCopyWith<_$CreateFlowStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
