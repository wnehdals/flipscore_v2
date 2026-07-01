import 'package:freezed_annotation/freezed_annotation.dart';

part 'usage_time.freezed.dart';
part 'usage_time.g.dart';

@freezed
abstract class UsageTime with _$UsageTime {
  const factory UsageTime({
    required String userId,
    required int remainingSeconds,
    required int adsWatchedToday,
    required DateTime lastAdDate,
    required DateTime updatedAt,
  }) = _UsageTime;

  factory UsageTime.fromJson(Map<String, dynamic> json) =>
      _$UsageTimeFromJson(json);
}

extension UsageTimeX on UsageTime {
  bool get canWatchAd => adsWatchedToday < 3;
  bool get hasTime => remainingSeconds > 0;

  String get remainingFormatted {
    final m = remainingSeconds ~/ 60;
    final s = remainingSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }
}
