import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/models/enums.dart';
import '../../../../shared/widgets/app_nav_rail.dart' show AppBottomNav;
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../create/presentation/providers/create_flow_provider.dart';
import '../../../viewer/domain/services/eye_gesture_recognizer.dart'
    show GestureSensitivityConfig;
import '../providers/gesture_sensitivity_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            child: Text('설정', style: AppTextStyles.title),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                _SectionTitle('제스처 설정'),
                const _GestureSensitivityCard(),
                const SizedBox(height: 24),
                _SectionTitle('앱 정보'),
                _SettingsTile(
                  icon: Icons.play_circle_outline,
                  label: '가이드 다시 보기',
                  onTap: () => context.push('/onboarding'),
                ),
                const _AppVersionTile(),
                const SizedBox(height: 24),
                _SectionTitle('계정'),
                _SettingsTile(
                  icon: Icons.logout,
                  label: '로그아웃',
                  onTap: () async {
                    await ref
                        .read(authRepositoryProvider)
                        .signOut();
                    if (context.mounted) context.go('/login');
                  },
                ),
                _SettingsTile(
                  icon: Icons.person_remove_outlined,
                  label: '회원 탈퇴',
                  labelColor: const Color(0xFFE53935),
                  trailing: const SizedBox.shrink(),
                  onTap: () => _handleDeleteAccount(context, ref),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> _handleDeleteAccount(BuildContext context, WidgetRef ref) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text('회원 탈퇴', style: AppTextStyles.subtitle),
      content: Text(
        '탈퇴하면 저장된 악보뷰어와 계정 정보가 모두 삭제되며 복구할 수 없습니다.\n정말 탈퇴하시겠어요?',
        style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: Text('취소',
              style: AppTextStyles.body.copyWith(color: AppColors.textTertiary)),
        ),
        FilledButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFFE53935),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text('탈퇴', style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );

  if (confirmed != true) return;

  try {
    await ref.read(localScoreViewerRepositoryProvider).deleteAll();
    await ref.read(authRepositoryProvider).deleteAccount();
    if (context.mounted) context.go('/login');
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('탈퇴 처리 중 오류가 발생했습니다: $e')),
      );
    }
  }
}

class _AppVersionTile extends StatelessWidget {
  const _AppVersionTile();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        final info = snapshot.data;
        final versionLabel = info == null
            ? ''
            : 'v${info.version} (${info.buildNumber})';
        return _SettingsTile(
          icon: Icons.info_outline,
          label: '버전 정보',
          trailing: Text(
            versionLabel,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
          onTap: null,
        );
      },
    );
  }
}

class _GestureSensitivityCard extends ConsumerWidget {
  const _GestureSensitivityCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sensitivityAsync = ref.watch(gestureSensitivityControllerProvider);

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('감지 민감도', style: AppTextStyles.body),
          SizedBox(height: 4),
          Text(
            '제스처가 잘 인식되지 않으면 민감도를 높여보세요.',
            style: AppTextStyles.caption
                .copyWith(color: AppColors.textSecondary),
          ),
          SizedBox(height: 12),
          sensitivityAsync.when(
            data: (current) => SegmentedButton<GestureSensitivity>(
              segments: [
                for (final level in GestureSensitivity.values)
                  ButtonSegment(value: level, label: Text(level.label)),
              ],
              selected: {current},
              onSelectionChanged: (selection) {
                ref
                    .read(gestureSensitivityControllerProvider.notifier)
                    .setSensitivity(selection.first);
              },
            ),
            loading: () => const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
            error: (_, _) => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: AppTextStyles.caption
            .copyWith(color: AppColors.textTertiary, letterSpacing: 0.5),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.labelColor,
    this.trailing,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Color? labelColor;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        leading: Icon(icon, color: labelColor ?? AppColors.textSecondary, size: 20),
        title: Text(label,
            style: AppTextStyles.body.copyWith(color: labelColor)),
        trailing: trailing ??
            const Icon(Icons.chevron_right,
                color: AppColors.textTertiary, size: 20),
        onTap: onTap,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
