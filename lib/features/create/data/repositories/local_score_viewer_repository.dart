import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../../../../shared/models/score_viewer.dart';
import '../../../../shared/models/score_viewer_timeline.dart';

class LocalScoreViewerRepository {
  Future<Directory> _viewerDir(String id) async {
    final base = await getApplicationSupportDirectory();
    final dir = Directory('${base.path}/flip_score/$id');
    await dir.create(recursive: true);
    return dir;
  }

  Future<Directory> _scoresDir(String id) async {
    final parent = await _viewerDir(id);
    final dir = Directory('${parent.path}/scores');
    await dir.create(recursive: true);
    return dir;
  }

  Future<Directory> _audioDir(String id) async {
    final parent = await _viewerDir(id);
    final dir = Directory('${parent.path}/audio');
    await dir.create(recursive: true);
    return dir;
  }

  /// 파일을 내부 저장소로 복사 후 ScoreViewer 저장.
  /// [sourceScorePaths]가 비어있으면 기존 pages를 그대로 유지합니다 (메타데이터만 업데이트).
  Future<ScoreViewer> saveWithFiles({
    required ScoreViewer viewer,
    required List<String> sourceScorePaths,
    String? sourceSongPath,
  }) async {
    final scoresDir = await _scoresDir(viewer.id);

    // 악보 파일 복사 (경로가 있을 때만)
    final pages = <ScorePage>[];
    if (sourceScorePaths.isNotEmpty) {
      for (var i = 0; i < sourceScorePaths.length; i++) {
        final src = File(sourceScorePaths[i]);
        final ext = sourceScorePaths[i].split('.').last;
        final dest = File('${scoresDir.path}/page_${(i + 1).toString().padLeft(2, '0')}.$ext');
        await src.copy(dest.path);
        pages.add(ScorePage(
          id: 'page_$i',
          order: i,
          type: viewer.pages[i].type,
          localPath: dest.path,
        ));
      }
    }

    // 노래 파일 복사
    String? copiedSongPath;
    if (sourceSongPath != null) {
      final audioDir = await _audioDir(viewer.id);
      final ext = sourceSongPath.split('.').last;
      final dest = File('${audioDir.path}/song.$ext');
      await File(sourceSongPath).copy(dest.path);
      copiedSongPath = dest.path;
    }

    final saved = viewer.copyWith(
      pages: pages.isEmpty ? viewer.pages : pages,
      songId: copiedSongPath ?? viewer.songId,
    );

    await _writeJson(saved);
    return saved;
  }

  Future<void> _writeJson(ScoreViewer viewer) async {
    final dir = await _viewerDir(viewer.id);
    final file = File('${dir.path}/viewer.json');
    await file.writeAsString(jsonEncode(viewer.toJson()));
  }

  Future<void> saveTimeline(ScoreViewerTimeline timeline) async {
    final dir = await _viewerDir(timeline.scoreViewerId);
    final file = File('${dir.path}/timeline.json');
    await file.writeAsString(jsonEncode(timeline.toJson()));
  }

  Future<List<ScoreViewer>> loadAll() async {
    final base = await getApplicationSupportDirectory();
    final root = Directory('${base.path}/flip_score');
    if (!await root.exists()) return [];

    final viewers = <ScoreViewer>[];
    await for (final entity in root.list()) {
      if (entity is! Directory) continue;
      final file = File('${entity.path}/viewer.json');
      if (!await file.exists()) continue;
      try {
        final json = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
        viewers.add(ScoreViewer.fromJson(json));
      } catch (_) {
        // 손상된 파일은 건너뜀
      }
    }

    viewers.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return viewers;
  }

  Future<ScoreViewerTimeline?> loadTimeline(String viewerId) async {
    final dir = await _viewerDir(viewerId);
    final file = File('${dir.path}/timeline.json');
    if (!await file.exists()) return null;
    try {
      final json = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
      return ScoreViewerTimeline.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  Future<void> updateViewer(ScoreViewer viewer) async {
    await _writeJson(viewer);
  }

  Future<void> delete(String id) async {
    final dir = await _viewerDir(id);
    if (await dir.exists()) await dir.delete(recursive: true);
  }
}
