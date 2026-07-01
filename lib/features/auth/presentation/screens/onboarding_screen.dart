import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../providers/auth_provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;
  bool _isFinishing = false;

  static const _pages = [
    _OnboardingPage(
      icon: Icons.queue_music_rounded,
      iconColor: AppColors.primary,
      title: 'FlipScore에 오신 것을\n환영합니다',
      body: '손 대지 않고 악보를 넘기는\n스마트 악보 뷰어입니다.',
    ),
    _OnboardingPage(
      icon: Icons.library_music_rounded,
      iconColor: Color(0xFF6B76E8),
      title: '악보뷰어란?',
      body: '사진이나 PDF로 만든 악보 묶음입니다.\n한 번 만들면 언제든 바로 실행할 수 있어요.',
    ),
    _OnboardingPage(
      icon: Icons.photo_library_rounded,
      iconColor: Color(0xFF43A047),
      title: '악보 불러오기',
      body: '사진 여러 장을 순서대로 선택하거나\nPDF 파일을 통째로 불러올 수 있어요.',
    ),
    _OnboardingPage(
      icon: Icons.auto_awesome_rounded,
      iconColor: AppColors.playerAccent,
      title: '노래에 맞춰\n자동으로 넘어가요',
      body: '타임라인을 설정하면\n악보가 박자에 맞게 자동으로 전환됩니다.',
    ),
    _OnboardingPage(
      icon: Icons.visibility_rounded,
      iconColor: Color(0xFF3A46B8),
      title: '눈 깜빡임 하나로\n핸즈프리 제어',
      body: '윙크나 눈 깜빡임으로\n손을 쓰지 않고도 악보를 넘길 수 있어요.',
    ),
    _OnboardingPage(
      icon: Icons.timer_rounded,
      iconColor: Color(0xFFF57C00),
      title: '이용시간 안내',
      body: '하루 3회 광고 시청으로 각 10분씩 충전하거나\n구독하면 무제한으로 사용할 수 있어요.',
    ),
    _OnboardingPage(
      icon: Icons.rocket_launch_rounded,
      iconColor: AppColors.primary,
      title: '이제 시작해볼까요?',
      body: '첫 번째 악보뷰어를 만들어\n연주를 더 자유롭게 즐겨보세요!',
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _next() async {
    if (_page < _pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      await _finish();
    }
  }

  Future<void> _skip() async {
    await _finish();
  }

  Future<void> _finish() async {
    if (_isFinishing) return;
    setState(() => _isFinishing = true);
    try {
      await ref.read(authRepositoryProvider).completeOnboarding();
    } finally {
      if (mounted) context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _page == _pages.length - 1;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // 헤더: 건너뛰기 버튼 (마지막 슬라이드 제외)
            SizedBox(
              height: 56,
              child: isLast
                  ? const SizedBox.shrink()
                  : Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20, top: 12),
                        child: TextButton(
                          onPressed: _isFinishing ? null : _skip,
                          child: Text(
                            '건너뛰기',
                            style: AppTextStyles.label
                                .copyWith(color: AppColors.textSecondary),
                          ),
                        ),
                      ),
                    ),
            ),

            // 슬라이드 콘텐츠
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (_, i) => _pages[i],
              ),
            ),

            // 하단: 인디케이터 + 버튼
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 0, 32, 40),
              child: Row(
                children: [
                  // 페이지 인디케이터
                  Row(
                    children: List.generate(
                      _pages.length,
                      (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        width: i == _page ? 20 : 6,
                        height: 6,
                        margin: const EdgeInsets.only(right: 4),
                        decoration: BoxDecoration(
                          color: i == _page ? AppColors.primary : AppColors.border,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  // 다음/시작하기 버튼
                  FilledButton(
                    onPressed: _isFinishing ? null : _next,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isFinishing && isLast
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            isLast ? '시작하기' : '다음',
                            style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(28),
            ),
            child: Icon(icon, size: 48, color: iconColor),
          ),
          const SizedBox(height: 32),
          Text(
            title,
            style: AppTextStyles.title.copyWith(height: 1.4),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            body,
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
