import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

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
        title: Text('이용약관', style: AppTextStyles.subtitle),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppColors.divider, height: 1),
        ),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: _TermsContent(),
      ),
    );
  }
}

class _TermsContent extends StatelessWidget {
  const _TermsContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle('제1조 (목적)'),
        _Body(
          '본 약관은 FlipScore(이하 "서비스")를 이용함에 있어 서비스 제공자와 이용자 간의 권리·의무 및 책임 사항을 규정함을 목적으로 합니다.',
        ),
        const SizedBox(height: 20),
        _SectionTitle('제2조 (정의)'),
        _Body(
          '"서비스"란 악보를 핸즈프리로 넘길 수 있도록 제공되는 FlipScore 애플리케이션 및 관련 제반 서비스를 의미합니다.\n'
          '"이용자"란 본 약관에 동의하고 서비스를 이용하는 자를 말합니다.',
        ),
        const SizedBox(height: 20),
        _SectionTitle('제3조 (약관의 효력 및 변경)'),
        _Body(
          '본 약관은 서비스 내 공지 또는 앱 스토어 업데이트를 통해 공시함으로써 효력이 발생합니다. '
          '서비스 제공자는 필요한 경우 약관을 변경할 수 있으며, 변경 시 사전 공지합니다.',
        ),
        const SizedBox(height: 20),
        _SectionTitle('제4조 (서비스 이용)'),
        _Body(
          '이용자는 서비스를 통해 악보 파일(PDF·이미지)을 업로드하고, 눈 제스처·노래 인식 기반의 자동 페이지 전환 기능을 이용할 수 있습니다. '
          '서비스 일부 기능은 구독 결제 또는 광고 시청 후 이용 가능합니다.',
        ),
        const SizedBox(height: 20),
        _SectionTitle('제5조 (이용자의 의무)'),
        _Body(
          '이용자는 다음 행위를 해서는 안 됩니다.\n'
          '• 타인의 저작권을 침해하는 악보 파일 업로드\n'
          '• 서비스의 정상적인 운영을 방해하는 행위\n'
          '• 본인 이외의 제3자에게 계정을 양도·공유하는 행위',
        ),
        const SizedBox(height: 20),
        _SectionTitle('제6조 (면책조항)'),
        _Body(
          '서비스 제공자는 천재지변, 서버 장애 등 불가항력으로 인한 서비스 중단에 대해 책임을 지지 않습니다. '
          '이용자가 업로드한 콘텐츠에 대한 법적 책임은 이용자 본인에게 있습니다.',
        ),
        const SizedBox(height: 20),
        _SectionTitle('제7조 (관할법원)'),
        _Body('본 약관에 관한 분쟁은 대한민국 법률에 따르며, 관할 법원은 서비스 제공자 소재지 법원으로 합니다.'),
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