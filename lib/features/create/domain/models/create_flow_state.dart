import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../shared/models/enums.dart';
import '../../../../shared/models/score_viewer.dart';
import '../../../../shared/models/score_viewer_timeline.dart';

part 'create_flow_state.freezed.dart';

@freezed
abstract class CreateFlowState with _$CreateFlowState {
  const CreateFlowState._();

  const factory CreateFlowState({
    @Default('') String title,
    ScoreType? scoreType,
    @Default([]) List<String> scorePaths,
    TransitionMode? transitionMode,
    String? songPath,
    String? songTitle,
    GestureType? gestureType,
    @Default([]) List<TimelineEntry> timelineEntries,
    @Default(false) bool isSaving,
    String? saveError,
    ScoreViewer? editingViewer,
  }) = _CreateFlowState;

  bool get isEditing => editingViewer != null;
}
