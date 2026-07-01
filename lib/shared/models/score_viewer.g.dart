// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'score_viewer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ScoreViewerImpl _$$ScoreViewerImplFromJson(
  Map<String, dynamic> json,
) => _$ScoreViewerImpl(
  id: json['id'] as String,
  title: json['title'] as String,
  transitionMode: $enumDecode(_$TransitionModeEnumMap, json['transitionMode']),
  pages: (json['pages'] as List<dynamic>)
      .map((e) => ScorePage.fromJson(e as Map<String, dynamic>))
      .toList(),
  songId: json['songId'] as String?,
  songTitle: json['songTitle'] as String?,
  gestureType: $enumDecodeNullable(_$GestureTypeEnumMap, json['gestureType']),
  hasTimeline: json['hasTimeline'] as bool? ?? false,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$$ScoreViewerImplToJson(_$ScoreViewerImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'transitionMode': _$TransitionModeEnumMap[instance.transitionMode]!,
      'pages': instance.pages,
      'songId': instance.songId,
      'songTitle': instance.songTitle,
      'gestureType': _$GestureTypeEnumMap[instance.gestureType],
      'hasTimeline': instance.hasTimeline,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$TransitionModeEnumMap = {
  TransitionMode.song: 'song',
  TransitionMode.gesture: 'gesture',
  TransitionMode.manual: 'manual',
};

const _$GestureTypeEnumMap = {
  GestureType.leftWink: 'leftWink',
  GestureType.rightWink: 'rightWink',
  GestureType.blink: 'blink',
  GestureType.smile: 'smile',
};

_$ScorePageImpl _$$ScorePageImplFromJson(Map<String, dynamic> json) =>
    _$ScorePageImpl(
      id: json['id'] as String,
      order: (json['order'] as num).toInt(),
      type: $enumDecode(_$ScoreTypeEnumMap, json['type']),
      localPath: json['localPath'] as String,
      storagePath: json['storagePath'] as String?,
    );

Map<String, dynamic> _$$ScorePageImplToJson(_$ScorePageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'order': instance.order,
      'type': _$ScoreTypeEnumMap[instance.type]!,
      'localPath': instance.localPath,
      'storagePath': instance.storagePath,
    };

const _$ScoreTypeEnumMap = {ScoreType.pdf: 'pdf', ScoreType.image: 'image'};
