import 'package:freezed_annotation/freezed_annotation.dart';

part 'score_viewer_timeline.freezed.dart';
part 'score_viewer_timeline.g.dart';

@freezed
abstract class ScoreViewerTimeline with _$ScoreViewerTimeline {
  const factory ScoreViewerTimeline({
    required String id,
    required String scoreViewerId,
    required List<TimelineEntry> entries,
    required DateTime updatedAt,
  }) = _ScoreViewerTimeline;

  factory ScoreViewerTimeline.fromJson(Map<String, dynamic> json) =>
      _$ScoreViewerTimelineFromJson(json);
}

@freezed
abstract class TimelineEntry with _$TimelineEntry {
  const factory TimelineEntry({
    required int pageIndex,
    required int timestampMs, // Duration → ms로 저장해 JSON 직렬화 안정성 확보
  }) = _TimelineEntry;

  factory TimelineEntry.fromJson(Map<String, dynamic> json) =>
      _$TimelineEntryFromJson(json);
}

extension TimelineEntryX on TimelineEntry {
  Duration get timestamp => Duration(milliseconds: timestampMs);
}
