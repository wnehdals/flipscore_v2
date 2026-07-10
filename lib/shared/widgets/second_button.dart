import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class SecondButton extends StatelessWidget {
  const SecondButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.surface,
          foregroundColor: const Color(0xFF8A8C90),
          side: const BorderSide(color: Color(0xFFCDCACE)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        child: Text(
          label,
          style: AppTextStyles.body.copyWith(color: const Color(0xFF8A8C90), fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
