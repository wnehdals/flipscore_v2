import 'package:freezed_annotation/freezed_annotation.dart';
import 'enums.dart';

part 'score_viewer.freezed.dart';
part 'score_viewer.g.dart';

@freezed
abstract class ScoreViewer with _$ScoreViewer {
  const factory ScoreViewer({
    required String id,
    required String title,
    required TransitionMode transitionMode,
    required List<ScorePage> pages,
    String? songId,
    String? songTitle,
    GestureType? gestureType,
    @Default(false) bool hasTimeline,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ScoreViewer;

  factory ScoreViewer.fromJson(Map<String, dynamic> json) =>
      _$ScoreViewerFromJson(json);
}

@freezed
abstract class ScorePage with _$ScorePage {
  const factory ScorePage({
    required String id,
    required int order,
    required ScoreType type,
    required String localPath,
    String? storagePath,
  }) = _ScorePage;

  factory ScorePage.fromJson(Map<String, dynamic> json) =>
      _$ScorePageFromJson(json);
}
