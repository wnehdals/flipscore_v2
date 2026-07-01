// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'score_viewer_timeline.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ScoreViewerTimelineImpl _$$ScoreViewerTimelineImplFromJson(
  Map<String, dynamic> json,
) => _$ScoreViewerTimelineImpl(
  id: json['id'] as String,
  scoreViewerId: json['scoreViewerId'] as String,
  entries: (json['entries'] as List<dynamic>)
      .map((e) => TimelineEntry.fromJson(e as Map<String, dynamic>))
      .toList(),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$$ScoreViewerTimelineImplToJson(
  _$ScoreViewerTimelineImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'scoreViewerId': instance.scoreViewerId,
  'entries': instance.entries,
  'updatedAt': instance.updatedAt.toIso8601String(),
};

_$TimelineEntryImpl _$$TimelineEntryImplFromJson(Map<String, dynamic> json) =>
    _$TimelineEntryImpl(
      pageIndex: (json['pageIndex'] as num).toInt(),
      timestampMs: (json['timestampMs'] as num).toInt(),
    );

Map<String, dynamic> _$$TimelineEntryImplToJson(_$TimelineEntryImpl instance) =>
    <String, dynamic>{
      'pageIndex': instance.pageIndex,
      'timestampMs': instance.timestampMs,
    };
