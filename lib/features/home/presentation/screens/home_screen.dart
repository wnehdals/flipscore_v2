import 'package:flipscore/core/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/models/score_viewer.dart';
import '../../../../shared/models/subscription.dart';
import '../../../../shared/widgets/app_nav_rail.dart' show AppBottomNav;
import '../../../create/presentation/providers/create_flow_provider.dart';
import '../../../usage_time/presentation/providers/subscription_provider.dart';
import '../../../usage_time/presentation/providers/usage_time_provider.dart';
import '../providers/home_providers.dart';
import '../widgets/score_viewer_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listAsync = ref.watch(scoreViewerListProvider);
    final subAsync = ref.watch(currentSubscriptionProvider);
    final usageAsync = ref.watch(currentUsageTimeProvider);

    final sub = subAsync.valueOrNull ?? Subscription.initial();
    final remainingSeconds = usageAsync.valueOrNull?.remainingSeconds ?? 0;

    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: const AppBottomNav(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HomeHeader(
              isSubscribed: sub.isActive,
              remainingSeconds: remainingSeconds,
              onCreate: () => context.push('/create/scores'),
            ),
            Expanded(
              child: listAsync.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
                error: (e, _) => Center(
                  child: Text('불러오기 실패: $e', style: AppTextStyles.body),
                ),
                data: (list) => _ScoreViewerGrid(
                  viewers: list,
                  isSubscribed: sub.isActive,
                  remainingSeconds: remainingSeconds,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({
    required this.isSubscribed,
    required this.remainingSeconds,
    required this.onCreate,
  });

  final bool isSubscribed;
  final int remainingSeconds;
  final VoidCallback onCreate;

  String get _timeLabel {
    if (isSubscribed) return '구독 중';
    final h = remainingSeconds ~/ 3600;
    final m = (remainingSeconds % 3600) ~/ 60;
    final s = remainingSeconds % 60;
    if (remainingSeconds == 0) return '0초';
    if (h > 0) return '$h시간 $m분';
    if (m > 0) return '$m분 $s초';
    return '$s초';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('내 악보뷰어', style: AppTextStyles.title),
            ],
          ),
          const Spacer(),
          // 잔여 이용시간 배지
          GestureDetector(
            onTap: () => context.push('/usage-time'),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isSubscribed
                    ? AppColors.textTertiary
                    : remainingSeconds > 0
                    ? AppColors.inputBorder
                    : const Color(0xFFFFEEEE),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isSubscribed ? Icons.all_inclusive : Icons.timer_outlined,
                    size: 14,
                    color: isSubscribed
                        ? AppColors.primary
                        : remainingSeconds > 0
                        ? AppColors.primary
                        : const Color(0xFFE53935),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    _timeLabel,
                    style: AppTextStyles.caption.copyWith(
                      color: isSubscribed
                          ? AppColors.textPrimary
                          : remainingSeconds > 0
                          ? AppColors.textPrimary
                          : const Color(0xFFE53935),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          /*
          const SizedBox(width: 16),
          FilledButton.icon(
            onPressed: onCreate,
            icon: const Icon(Icons.add, size: 18),
            label: Text(
              '새 악보뷰어',
              style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
            ),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          */
        ],
      ),
    );
  }
}

class _ScoreViewerGrid extends ConsumerWidget {
  const _ScoreViewerGrid({
    required this.viewers,
    required this.isSubscribed,
    required this.remainingSeconds,
  });

  final List<ScoreViewer> viewers;
  final bool isSubscribed;
  final int remainingSeconds;

  void _onCardTap(BuildContext context, ScoreViewer v) {
    if (isSubscribed || remainingSeconds > 0) {
      context.push('/viewer/${v.id}');
      return;
    }
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('이용시간이 없어요', style: AppTextStyles.subtitle),
        content: Text(
          '광고를 시청하거나 구독하면\n악보뷰어를 실행할 수 있습니다.',
          style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              '취소',
              style: AppTextStyles.body.copyWith(color: AppColors.textTertiary),
            ),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.push('/usage-time');
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('이용시간 얻기', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _onCardLongPress(BuildContext context, WidgetRef ref, ScoreViewer v) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _CardActionsSheet(
        viewerTitle: v.title,
        onEdit: () {
          Navigator.of(context).pop();
          ref.read(createFlowNotifierProvider.notifier).loadForEdit(v);
          context.push('/create/scores');
        },
        onDelete: () {
          Navigator.of(context).pop();
          _confirmDelete(context, ref, v);
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, ScoreViewer v) {
    showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('삭제하시겠어요?', style: AppTextStyles.subtitle),
        content: Text(
          '"${v.title}"을(를) 삭제하면 복구할 수 없습니다.',
          style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              '취소',
              style: AppTextStyles.body.copyWith(color: AppColors.textTertiary),
            ),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFE53935),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('삭제', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    ).then((confirmed) async {
      if (confirmed != true) return;
      await ref.read(localScoreViewerRepositoryProvider).delete(v.id);
      ref.invalidate(scoreViewerListProvider);
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GridView.builder(
      padding: const EdgeInsets.all(24),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: Responsive.isTablet(context) ? 3 : 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.72,
      ),
      itemCount: viewers.length + 1,
      itemBuilder: (context, i) {
        if (i == viewers.length) {
          return _AddScoreViewerCard(
            onTap: () => context.push('/create/scores'),
          );
        }
        final v = viewers[i];
        return ScoreViewerCard(
          viewer: v,
          onTap: () => _onCardTap(context, v),
          onLongPress: () => _onCardLongPress(context, ref, v),
        );
      },
    );
  }
}

class _CardActionsSheet extends StatelessWidget {
  const _CardActionsSheet({
    required this.viewerTitle,
    required this.onEdit,
    required this.onDelete,
  });

  final String viewerTitle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                viewerTitle,
                style: AppTextStyles.subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 12),
            const Divider(height: 1, color: AppColors.divider),
            _ActionTile(
              icon: Icons.edit_outlined,
              label: '수정',
              color: AppColors.dark,
              onTap: onEdit,
            ),
            const Divider(
              height: 1,
              indent: 20,
              endIndent: 20,
              color: AppColors.divider,
            ),
            _ActionTile(
              icon: Icons.delete_outline,
              label: '삭제',
              color: const Color(0xFFE53935),
              onTap: onDelete,
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Icon(icon, size: 22, color: color),
            const SizedBox(width: 14),
            Text(
              label,
              style: AppTextStyles.body.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddScoreViewerCard extends StatelessWidget {
  const _AddScoreViewerCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryLight,
              ),
              child: const Icon(
                Icons.add_rounded,
                size: 28,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '새 악보뷰어\n만들기',
              textAlign: TextAlign.center,
              style: AppTextStyles.cardTitle.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
