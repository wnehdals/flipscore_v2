import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/models/score_viewer.dart';
import '../../../../shared/models/score_viewer_timeline.dart';
import '../../../../shared/widgets/timeline_editor.dart';
import '../../../create/presentation/providers/create_flow_provider.dart';

class ViewerTimelineScreen extends ConsumerStatefulWidget {
  const ViewerTimelineScreen({super.key, required this.viewerId});
  final String viewerId;

  @override
  ConsumerState<ViewerTimelineScreen> createState() =>
      _ViewerTimelineScreenState();
}

class _ViewerTimelineScreenState extends ConsumerState<ViewerTimelineScreen> {
  ScoreViewer? _viewer;
  List<TimelineEntry> _entries = [];
  int _totalPages = 0;
  bool _loading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final repo = ref.read(localScoreViewerRepositoryProvider);
    final all = await repo.loadAll();
    _viewer = all.where((v) => v.id == widget.viewerId).firstOrNull;

    if (_viewer != null && _viewer!.hasTimeline) {
      final tl = await repo.loadTimeline(widget.viewerId);
      if (tl != null) _entries = [...tl.entries];
    }

    if (mounted) setState(() => _loading = false);
  }

  void _onAddEntry(Duration position) {
    final pageIndex = _entries.length + 1;
    if (pageIndex >= _totalPages) return;
    setState(() {
      _entries = [
        ..._entries,
        TimelineEntry(
            pageIndex: pageIndex, timestampMs: position.inMilliseconds),
      ];
    });
  }

  void _onRemoveEntry(int index) {
    setState(() => _entries = [..._entries]..removeAt(index));
  }

  Future<void> _save() async {
    final viewer = _viewer;
    if (viewer == null) return;

    final requiredCount = _totalPages - 1;
    if (requiredCount > 0 && _entries.length < requiredCount) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                '모든 페이지의 전환 시점을 설정해주세요 ($requiredCount개 필요)')),
      );
      return;
    }

    setState(() => _isSaving = true);
    try {
      final repo = ref.read(localScoreViewerRepositoryProvider);
      final now = DateTime.now();
      await repo.saveTimeline(ScoreViewerTimeline(
        id: widget.viewerId,
        scoreViewerId: widget.viewerId,
        entries: _entries,
        updatedAt: now,
      ));
      await repo.updateViewer(
          viewer.copyWith(hasTimeline: true, updatedAt: now));
      if (mounted) context.go('/viewer/${widget.viewerId}');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('저장 실패: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
            child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }

    if (_viewer == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Text('악보뷰어를 찾을 수 없습니다',
              style:
                  AppTextStyles.body.copyWith(color: AppColors.textSecondary)),
        ),
      );
    }

    final viewer = _viewer!;
    final pages = viewer.pages
        .map((p) => TimelineEditorPage(localPath: p.localPath, type: p.type))
        .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.dark),
          onPressed: () =>
              context.canPop() ? context.pop() : context.go('/'),
        ),
        title: Text('타임라인 설정', style: AppTextStyles.subtitle),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: TextButton(
              onPressed: _isSaving ? null : _save,
              child: _isSaving
                  ? SizedBox(
                      width: 18,
                      height: 18,
                      child: const CircularProgressIndicator(
                          strokeWidth: 2, color: AppColors.primary),
                    )
                  : Text('저장',
                      style: AppTextStyles.bodyMedium
                          .copyWith(color: AppColors.primary)),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: TimelineEditorBody(
          pages: pages,
          songPath: viewer.songId,
          entries: _entries,
          onAddEntry: _onAddEntry,
          onRemoveEntry: _onRemoveEntry,
          onTotalPagesChanged: (count) =>
              setState(() => _totalPages = count),
        ),
      ),
    );
  }
}
