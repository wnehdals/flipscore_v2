import 'package:flipscore/core/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/models/enums.dart';
import '../../../../shared/widgets/step_bar.dart';
import '../providers/create_flow_provider.dart';

class CreateGestureScreen extends ConsumerWidget {
  const CreateGestureScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(createFlowNotifierProvider);
    final notifier = ref.read(createFlowNotifierProvider.notifier);

    Future<void> save() async {
      if (state.gestureType == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('제스처 종류를 선택해주세요')),
        );
        return;
      }
      final id = await notifier.save();
      if (!context.mounted) return;
      if (id != null) {
        context.go('/');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.saveError ?? '저장에 실패했습니다')),
        );
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
        title: Text('제스처 선택', style: AppTextStyles.subtitle),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(3),
          child: StepBar(step: 3, total: 3),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('제스처 종류 선택', style: AppTextStyles.title),
                      const SizedBox(height: 8),
                      Text(
                        '선택한 제스처를 감지하면 다음 악보로 넘어갑니다.',
                        style: AppTextStyles.body
                            .copyWith(color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 28),
                      GridView.count(
                        crossAxisCount: Responsive.isTablet(context) ? 3 : 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 2.8,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          _GestureCard(
                            label: '왼쪽 눈 윙크',
                            value: GestureType.leftWink,
                            selected: state.gestureType == GestureType.leftWink,
                            onTap: () => notifier.setGesture(GestureType.leftWink),
                          ),
                          _GestureCard(
                            label: '오른쪽 눈 윙크',
                            value: GestureType.rightWink,
                            selected: state.gestureType == GestureType.rightWink,
                            onTap: () => notifier.setGesture(GestureType.rightWink),
                          ),
                          _GestureCard(
                            label: '양눈 깜빡임',
                            value: GestureType.blink,
                            selected: state.gestureType == GestureType.blink,
                            onTap: () => notifier.setGesture(GestureType.blink),
                          ),
                        ],
                      ),
                      if (state.isSaving) ...[
                        const SizedBox(height: 24),
                        const Center(
                          child: CircularProgressIndicator(color: AppColors.primary),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
          _BottomBar(
            onNext: state.isSaving ? () {} : save,
            nextLabel: '저장',
          ),
        ],
      ),
    );
  }
}

class _GestureCard extends StatelessWidget {
  const _GestureCard({
    required this.label,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final GestureType value;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primaryLight : AppColors.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.border,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Text(
                label,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: selected ? AppColors.primary : AppColors.dark,
                ),
              ),
              const Spacer(),
              if (selected)
                const Icon(Icons.check_circle_rounded,
                    color: AppColors.primary, size: 20),
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
            child: Text(nextLabel,
                style: AppTextStyles.bodyMedium.copyWith(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
