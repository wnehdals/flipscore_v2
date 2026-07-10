import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../providers/force_update_provider.dart';

class ForceUpdateScreen extends ConsumerWidget {
  const ForceUpdateScreen({super.key});

  Future<void> _openStore(BuildContext context, String storeUrl) async {
    bool launched = false;
    try {
      final uri = Uri.parse(storeUrl);
      launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      launched = false;
    }
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('스토어를 열 수 없습니다.')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final infoAsync = ref.watch(forceUpdateCheckProvider);

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 48),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Icon(
                    Icons.system_update_alt_rounded,
                    size: 36,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: 24),
                Text('업데이트 안내', style: AppTextStyles.title),
                SizedBox(height: 8),
                Text(
                  infoAsync.valueOrNull?.message ??
                      '새로운 버전이 출시되었습니다.\n원활한 이용을 위해 업데이트해주세요.',
                  style: AppTextStyles.body.copyWith(color: AppColors.textSecondary, height: 1.6),
                ),
                SizedBox(height: 40),
                SizedBox(
                  height: 52,
                  child: FilledButton(
                    onPressed: () {
                      final info = infoAsync.valueOrNull;
                      if (info == null || info.storeUrl.isEmpty) return;
                      _openStore(context, info.storeUrl);
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      '업데이트하기',
                      style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
