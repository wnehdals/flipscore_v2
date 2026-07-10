import 'package:flipscore/core/utils/responsive.dart';
import 'package:flipscore/shared/widgets/prrimary_button.dart';
import 'package:flipscore/shared/widgets/vertical_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../providers/permission_notice_provider.dart';

class PermissionNoticeScreen extends ConsumerStatefulWidget {
  const PermissionNoticeScreen({super.key});

  @override
  ConsumerState<PermissionNoticeScreen> createState() =>
      _PermissionNoticeScreenState();
}

class _PermissionNoticeScreenState
    extends ConsumerState<PermissionNoticeScreen> {

  Future<void> _confirm() async {
    final success =
        await ref.read(permissionNoticeSeenProvider.notifier).markSeen();
    if (!mounted) return;
    if (success) {
      context.go('/login');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('처리 중 문제가 발생했습니다. 다시 시도해주세요.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(Responsive.horizontalPadding(context)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: VerticalScrollView(
                  children: [
                    Text(
                      '접근 권한 안내',
                      style: AppTextStyles.title,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'FlipScore가 원활히 동작하려면\n아래 권한에 대한 접근이 필요합니다.',
                      style: AppTextStyles.body.copyWith(color: AppColors.textSecondary, height: 1.6),
                    ),
                    SizedBox(height: 32),
                    _PermissionItem(
                      icon: Icons.camera_alt_outlined,
                      title: '카메라 (선택)',
                      description: '눈 깜빡임·윙크 제스처를 인식해\n손 없이 악보를 넘기는 기능에 사용됩니다.',
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              PrimaryButton(label: '확인', onPressed: _confirm),
            ],
          ),
        ),
      ),
    );
  }
}

class _PermissionItem extends StatelessWidget {
  const _PermissionItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: AppColors.primary),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.cardTitle),
                SizedBox(height: 4),
                Text(
                  description,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
