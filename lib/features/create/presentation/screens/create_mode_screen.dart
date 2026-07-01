import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/models/enums.dart';
import '../../../../shared/widgets/step_bar.dart';
import '../providers/create_flow_provider.dart';

class CreateModeScreen extends ConsumerWidget {
  const CreateModeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(createFlowNotifierProvider);
    final notifier = ref.read(createFlowNotifierProvider.notifier);

    void next() {
      switch (state.transitionMode) {
        case TransitionMode.song:
          context.push('/create/song');
        case TransitionMode.gesture:
          context.push('/create/gesture');
        case TransitionMode.manual:
        case null:
          _saveAndGo(context, ref);
      }
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.dark),
          onPressed: () => context.pop(),
        ),
        title: Text('전환 방식', style: AppTextStyles.subtitle),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(3),
          child: StepBar(step: 2, total: 3),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640),
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('악보를 어떻게 넘길까요?', style: AppTextStyles.title),
                      const SizedBox(height: 32),
                      _ModeCard(
                        icon: Icons.music_note_rounded,
                        iconColor: AppColors.badgeSongText,
                        iconBg: AppColors.badgeSong,
                        title: '노래로 자동 전환',
                        description: '타임라인을 설정하면 노래 재생에 맞춰\n자동으로 악보가 넘어갑니다.',
                        selected: state.transitionMode == TransitionMode.song,
                        onTap: () => notifier.setTransitionMode(TransitionMode.song),
                      ),
                      const SizedBox(height: 12),
                      _ModeCard(
                        icon: Icons.visibility_rounded,
                        iconColor: AppColors.badgeGestureText,
                        iconBg: AppColors.badgeGesture,
                        title: '눈 제스처로 전환',
                        description: '윙크나 눈 깜빡임으로\n핸즈프리로 악보를 넘깁니다.',
                        selected: state.transitionMode == TransitionMode.gesture,
                        onTap: () => notifier.setTransitionMode(TransitionMode.gesture),
                      ),
                      const SizedBox(height: 12),
                      _ModeCard(
                        icon: Icons.touch_app_rounded,
                        iconColor: AppColors.badgeNoneText,
                        iconBg: AppColors.badgeNone,
                        title: '수동 전환',
                        description: '화면 터치 또는 스와이프로\n직접 악보를 넘깁니다.',
                        selected: state.transitionMode == TransitionMode.manual ||
                            state.transitionMode == null,
                        onTap: () => notifier.setTransitionMode(TransitionMode.manual),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          _BottomBar(
            onNext: next,
            nextLabel: state.transitionMode == TransitionMode.song ||
                    state.transitionMode == TransitionMode.gesture
                ? '다음'
                : '저장',
          ),
        ],
      ),
    );
  }
}

Future<void> _saveAndGo(BuildContext context, WidgetRef ref) async {
  final id = await ref.read(createFlowNotifierProvider.notifier).save();
  if (!context.mounted) return;
  if (id != null) {
    context.go('/');
  } else {
    final err = ref.read(createFlowNotifierProvider).saveError ?? '저장 실패';
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(err)));
  }
}

class _ModeCard extends StatelessWidget {
  const _ModeCard({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.description,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String description;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primaryLight : AppColors.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.border,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.bodyMedium),
                    const SizedBox(height: 3),
                    Text(
                      description,
                      style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              if (selected)
                const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 22),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.onNext, required this.nextLabel});
  final VoidCallback onNext;
  final String nextLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FilledButton(
            onPressed: onNext,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 13),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text(nextLabel, style: AppTextStyles.bodyMedium.copyWith(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
