import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/app_nav_rail.dart' show AppBottomNav;
import '../providers/usage_time_provider.dart';
import '../providers/subscription_provider.dart';

class UsageTimeScreen extends ConsumerWidget {
  const UsageTimeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usageAsync = ref.watch(currentUsageTimeProvider);
    final subAsync = ref.watch(currentSubscriptionProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: const AppBottomNav(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                Text('이용시간', style: AppTextStyles.title),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: subAsync.when(
                loading: () => const CircularProgressIndicator(
                    color: AppColors.primary),
                error: (e, _) =>
                    Text('오류: $e', style: AppTextStyles.body),
                data: (sub) {
                  if (sub.isActive) {
                    return _SubscribedView();
                  }
                  return usageAsync.when(
                    loading: () => const CircularProgressIndicator(
                        color: AppColors.primary),
                    error: (e, _) =>
                        Text('오류: $e', style: AppTextStyles.body),
                    data: (usage) => _UsageView(
                      remainingSeconds: usage?.remainingSeconds ?? 0,
                      adsWatched: usage?.adsWatchedToday ?? 0,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SubscribedView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(24),
          ),
          child:
              const Icon(Icons.all_inclusive, size: 40, color: AppColors.primary),
        ),
        const SizedBox(height: 20),
        Text('구독 중', style: AppTextStyles.subtitle),
        const SizedBox(height: 8),
        Text(
          '무제한으로 사용 가능합니다',
          style: AppTextStyles.body
              .copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

class _UsageView extends StatelessWidget {
  const _UsageView({required this.remainingSeconds, required this.adsWatched});

  final int remainingSeconds;
  final int adsWatched;

  String get _formatted {
    final h = remainingSeconds ~/ 3600;
    final m = (remainingSeconds % 3600) ~/ 60;
    final s = remainingSeconds % 60;
    if (h > 0) return '$h시간 $m분';
    if (m > 0) return '$m분 $s초';
    return '$s초';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              _formatted,
              style: AppTextStyles.subtitle.copyWith(color: AppColors.primary),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text('잔여 이용시간', style: AppTextStyles.subtitle),
        const SizedBox(height: 16),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final watched = i < adsWatched;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Icon(
                watched ? Icons.circle : Icons.circle_outlined,
                size: 16,
                color: watched ? AppColors.primary : AppColors.border,
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        Text(
          '오늘 광고 시청: $adsWatched / 3',
          style:
              AppTextStyles.body.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 24),
        FilledButton.icon(
          onPressed: adsWatched >= 3 ? null : () {},
          icon: const Icon(Icons.play_circle_outline, size: 18),
          label: const Text('광고 보고 10분 얻기'),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            disabledBackgroundColor: AppColors.border,
            padding:
                const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }
}
