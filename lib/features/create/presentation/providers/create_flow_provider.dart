import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../../../shared/models/enums.dart';
import '../../../../shared/models/score_viewer.dart';
import '../../../../shared/models/score_viewer_timeline.dart';
import '../../../home/presentation/providers/home_providers.dart';
import '../../data/repositories/local_score_viewer_repository.dart';
import '../../domain/models/create_flow_state.dart';

part 'create_flow_provider.g.dart';

@Riverpod(keepAlive: true)
LocalScoreViewerRepository localScoreViewerRepository(Ref ref) =>
    LocalScoreViewerRepository();

@Riverpod(keepAlive: true)
class CreateFlowNotifier extends _$CreateFlowNotifier {
  @override
  CreateFlowState build() => const CreateFlowState(scoreType: ScoreType.image);

  void setTitle(String title) => state = state.copyWith(title: title);

  void setScoreType(ScoreType type) =>
      state = state.copyWith(scoreType: type, scorePaths: []);

  void setScorePaths(List<String> paths) =>
      state = state.copyWith(scorePaths: paths);

  void setTransitionMode(TransitionMode mode) => state = state.copyWith(
        transitionMode: mode,
        songPath: null,
        songTitle: null,
        gestureType: null,
        timelineEntries: [],
      );

  void setSong({required String path, required String title}) =>
      state = state.copyWith(songPath: path, songTitle: title);

  void setGesture(GestureType gesture) =>
      state = state.copyWith(gestureType: gesture);

  void addTimelineEntry(Duration position, {int? totalPages}) {
    final pageIndex = state.timelineEntries.length + 1;
    final limit = totalPages ?? state.scorePaths.length;
    if (pageIndex >= limit) return;
    state = state.copyWith(timelineEntries: [
      ...state.timelineEntries,
      TimelineEntry(pageIndex: pageIndex, timestampMs: position.inMilliseconds),
    ]);
  }

  void removeTimelineEntry(int index) {
    final entries = [...state.timelineEntries]..removeAt(index);
    state = state.copyWith(timelineEntries: entries);
  }

  void setTimelineEntries(List<TimelineEntry> entries) =>
      state = state.copyWith(timelineEntries: entries);

  void clearError() => state = state.copyWith(saveError: null);

  void reset() => state = const CreateFlowState(scoreType: ScoreType.image);

  void loadForEdit(ScoreViewer viewer) {
    final scoreType =
        viewer.pages.isEmpty ? ScoreType.image : viewer.pages.first.type;
    state = CreateFlowState(
      editingViewer: viewer,
      title: viewer.title,
      scoreType: scoreType,
      scorePaths: viewer.pages.map((p) => p.localPath).toList(),
      transitionMode: viewer.transitionMode,
      songPath: viewer.songId,
      songTitle: viewer.songTitle,
      gestureType: viewer.gestureType,
    );
  }

  Future<String?> save() async {
    state = state.copyWith(isSaving: true, saveError: null);

    try {
      final isEditing = state.isEditing;
      final id = state.editingViewer?.id ?? const Uuid().v4();
      final now = DateTime.now();

      final existingPaths =
          state.editingViewer?.pages.map((p) => p.localPath).toList() ?? [];
      final scoresUnchanged = isEditing &&
          state.scorePaths.length == existingPaths.length &&
          List.generate(
            state.scorePaths.length,
            (i) => state.scorePaths[i] == existingPaths[i],
          ).every((e) => e);

      final pages = state.scorePaths.asMap().entries.map((e) {
        final isImage = state.scoreType == ScoreType.image;
        return ScorePage(
          id: 'page_${e.key}',
          order: e.key,
          type: isImage ? ScoreType.image : ScoreType.pdf,
          localPath: e.value,
        );
      }).toList();

      final viewer = ScoreViewer(
        id: id,
        title: state.title.isEmpty ? '악보뷰어 ${now.month}/${now.day}' : state.title,
        transitionMode: state.transitionMode ?? TransitionMode.manual,
        pages: scoresUnchanged ? state.editingViewer!.pages : pages,
        songTitle: state.songTitle,
        gestureType: state.gestureType,
        hasTimeline: state.timelineEntries.isNotEmpty,
        createdAt: state.editingViewer?.createdAt ?? now,
        updatedAt: now,
      );

      final songChanged =
          !isEditing || state.songPath != state.editingViewer?.songId;

      final repo = ref.read(localScoreViewerRepositoryProvider);
      await repo.saveWithFiles(
        viewer: viewer,
        sourceScorePaths: scoresUnchanged ? [] : state.scorePaths,
        sourceSongPath: songChanged ? state.songPath : null,
      );

      if (state.timelineEntries.isNotEmpty) {
        await repo.saveTimeline(ScoreViewerTimeline(
          id: id,
          scoreViewerId: id,
          entries: state.timelineEntries,
          updatedAt: now,
        ));
      }

      state = state.copyWith(isSaving: false);
      reset();
      ref.invalidate(scoreViewerListProvider);
      return id;
    } catch (e) {
      state = state.copyWith(isSaving: false, saveError: e.toString());
      return null;
    }
  }
}
