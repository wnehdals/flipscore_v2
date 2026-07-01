import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../shared/models/score_viewer.dart';
import '../../../create/presentation/providers/create_flow_provider.dart';

part 'home_providers.g.dart';

@riverpod
Future<List<ScoreViewer>> scoreViewerList(Ref ref) async {
  return ref.watch(localScoreViewerRepositoryProvider).loadAll();
}
