import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/models/enums.dart';
import '../../../../shared/models/score_viewer_timeline.dart';
import '../../../../shared/widgets/step_bar.dart';
import '../../../../shared/widgets/timeline_editor.dart';
import '../providers/create_flow_provider.dart';

class CreateTimelineScreen extends ConsumerStatefulWidget {
  const CreateTimelineScreen({super.key});

  @override
  ConsumerState<CreateTimelineScreen> createState() =>
      _CreateTimelineScreenState();
}

class _CreateTimelineScreenState extends ConsumerState<CreateTimelineScreen> {
  List<TimelineEntry> _entries = [];
  int _totalPages = 0;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // 편집 모드 진입 시 기존 항목 복원
    _entries = [...ref.read(createFlowNotifierProvider).timelineEntries];
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

    // 부모 notifier에 항목을 반영한 뒤 save() 호출
    final notifier = ref.read(createFlowNotifierProvider.notifier);
    notifier.setTimelineEntries(_entries);
    final id = await notifier.save();

    if (!mounted) return;
    setState(() => _isSaving = false);

    if (id != null) {
      context.go('/');
    } else {
      final err =
          ref.read(createFlowNotifierProvider).saveError ?? '저장에 실패했습니다';
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(err)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final dp = Responsive.getDp;
    final state = ref.watch(createFlowNotifierProvider);

    // ScoreType.pdf → PDF 파일 한 항목, image → 각 경로별 항목
    final pages = state.scoreType == ScoreType.pdf && state.scorePaths.isNotEmpty
        ? [TimelineEditorPage(
            localPath: state.scorePaths.first, type: ScoreType.pdf)]
        : state.scorePaths
            .map((p) =>
                TimelineEditorPage(localPath: p, type: ScoreType.image))
            .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.dark),
          onPressed: () => context.pop(),
        ),
        title: Text('타임라인 설정', style: AppTextStyles.subtitle),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: dp(context, 12)),
            child: TextButton(
              onPressed: _isSaving ? null : _save,
              child: _isSaving
                  ? SizedBox(
                      width: dp(context, 18),
                      height: dp(context, 18),
                      child: const CircularProgressIndicator(
                          strokeWidth: 2, color: AppColors.primary),
                    )
                  : Text('저장',
                      style: AppTextStyles.bodyMedium
                          .copyWith(color: AppColors.primary)),
            ),
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(3),
          child: StepBar(step: 4, total: 4),
        ),
      ),
      body: SafeArea(
        child: TimelineEditorBody(
          pages: pages,
          songPath: state.songPath,
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
