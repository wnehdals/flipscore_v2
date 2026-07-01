import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              size: 18, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text('개인정보처리방침', style: AppTextStyles.subtitle),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppColors.divider, height: 1),
        ),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: _PrivacyContent(),
      ),
    );
  }
}

class _PrivacyContent extends StatelessWidget {
  const _PrivacyContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle('1. 수집하는 개인정보 항목'),
        _Body(
          'FlipScore는 서비스 제공을 위해 아래 정보를 수집합니다.\n'
          '• 소셜 로그인 시: 이름, 이메일 주소, 프로필 사진 (Google / Apple / Kakao 제공)\n'
          '• 서비스 이용 시: 이용 시간 기록, 악보 파일(기기 내 저장)\n'
          '• 자동 수집: 앱 버전, 기기 정보, 오류 로그(Crashlytics)',
        ),
        const SizedBox(height: 20),
        _SectionTitle('2. 개인정보 수집·이용 목적'),
        _Body(
          '• 회원 식별 및 서비스 제공\n'
          '• 구독 결제 및 이용 시간 관리\n'
          '• 서비스 품질 개선 및 오류 분석\n'
          '• 공지사항 및 서비스 안내',
        ),
        const SizedBox(height: 20),
        _SectionTitle('3. 개인정보 보유 및 이용 기간'),
        _Body(
          '이용자의 개인정보는 서비스 탈퇴 시 즉시 파기합니다. 단, 관련 법령에 의해 보존이 필요한 경우 해당 기간 동안 보관 후 삭제합니다.',
        ),
        const SizedBox(height: 20),
        _SectionTitle('4. 개인정보 제3자 제공'),
        _Body(
          'FlipScore는 이용자의 동의 없이 개인정보를 제3자에게 제공하지 않습니다. '
          '단, 법령에 의한 요청이 있거나 이용자가 사전에 동의한 경우는 예외로 합니다.',
        ),
        const SizedBox(height: 20),
        _SectionTitle('5. 개인정보 처리 위탁'),
        _Body(
          '• Google Firebase (인증, 데이터 저장, 분석)\n'
          '• Google AdMob (광고 제공)\n'
          '• 각 플랫폼의 개인정보처리방침에 따라 처리됩니다.',
        ),
        const SizedBox(height: 20),
        _SectionTitle('6. 이용자의 권리'),
        _Body(
          '이용자는 언제든지 개인정보 열람·수정·삭제를 요청할 수 있습니다. '
          '앱 설정 > 계정 관리 또는 고객센터를 통해 요청 가능합니다.',
        ),
        const SizedBox(height: 20),
        _SectionTitle('7. 개인정보 보호책임자'),
        _Body('이메일: dongmin960903@gmail.com'),
        const SizedBox(height: 32),
        Text(
          '시행일: 2025년 1월 1일',
          style: AppTextStyles.caption,
        ),
      ],
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
      child: Text(text, style: AppTextStyles.bodyMedium),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.body.copyWith(
        color: AppColors.textSecondary,
        height: 1.65,
      ),
    );
  }
}