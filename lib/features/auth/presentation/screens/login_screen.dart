import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/models/app_user.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authAsync = ref.watch(authNotifierProvider);

    ref.listen<AsyncValue<AppUser?>>(authNotifierProvider, (_, next) {
      next.whenData((user) {
        if (user == null) return;
        if (user.isFirstLogin) {
          context.go('/onboarding');
        } else {
          context.go('/');
        }
      });
    });

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.surface,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: AppColors.surface,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 36),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 48),
                SvgPicture.asset(
                  'assets/images/flip_score_logo.svg',
                  width: 76,
                  height: 76,
                ),
                const SizedBox(height: 36),
                Text(
                  'FlipScore',
                  style: AppTextStyles.headline.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 36,
                  ),
                ),
                Text(
                  '손대지 않고 넘기는 스마트 악보 뷰어',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 64),
                if (authAsync.isLoading)
                  const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  )
                else
                  _KakaoLoginButton(
                    onTap: () =>
                        ref.read(authNotifierProvider.notifier).signInWithKakao(),
                  ),
                if (authAsync.hasError) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.errorLight.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      authAsync.error.toString(),
                      style: AppTextStyles.label.copyWith(color: AppColors.error),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
                const SizedBox(height: 32),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textTertiary,
                    ),
                    children: [
                      const TextSpan(text: '계속 진행하면 '),
                      TextSpan(
                        text: '이용약관',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.textSecondary,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => context.push('/terms'),
                      ),
                      const TextSpan(text: ' 및 '),
                      TextSpan(
                        text: '개인정보처리방침',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.textSecondary,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => context.push('/privacy-policy'),
                      ),
                      const TextSpan(text: '에 동의하게 됩니다.'),
                    ],
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

class _KakaoLoginButton extends StatelessWidget {
  const _KakaoLoginButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFFEE500),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF191919),
                ),
                child: const Center(
                  child: Text(
                    'K',
                    style: TextStyle(
                      color: Color(0xFFFEE500),
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '카카오로 계속하기',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: const Color(0xFF191919),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
