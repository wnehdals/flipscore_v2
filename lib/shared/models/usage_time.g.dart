// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usage_time.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UsageTimeImpl _$$UsageTimeImplFromJson(Map<String, dynamic> json) =>
    _$UsageTimeImpl(
      userId: json['userId'] as String,
      remainingSeconds: (json['remainingSeconds'] as num).toInt(),
      adsWatchedToday: (json['adsWatchedToday'] as num).toInt(),
      lastAdDate: DateTime.parse(json['lastAdDate'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$UsageTimeImplToJson(_$UsageTimeImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'remainingSeconds': instance.remainingSeconds,
      'adsWatchedToday': instance.adsWatchedToday,
      'lastAdDate': instance.lastAdDate.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
