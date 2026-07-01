import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/models/score_viewer.dart';
import '../../../../shared/models/score_viewer_timeline.dart';
import '../../../create/presentation/providers/create_flow_provider.dart';

final viewerByIdProvider =
    FutureProvider.family<ScoreViewer?, String>((ref, id) async {
  final repo = ref.read(localScoreViewerRepositoryProvider);
  final all = await repo.loadAll();
  return all.where((v) => v.id == id).firstOrNull;
});

final viewerTimelineProvider =
    FutureProvider.family<ScoreViewerTimeline?, String>((ref, id) async {
  final repo = ref.read(localScoreViewerRepositoryProvider);
  return repo.loadTimeline(id);
});
