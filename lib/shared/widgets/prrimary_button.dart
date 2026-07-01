import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/responsive.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Responsive.getDp(context, 48),
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Responsive.getDp(context, 8)),
          ),
          padding: EdgeInsets.symmetric(horizontal: Responsive.getDp(context, 24)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: AppTextStyles.body.copyWith(color: AppColors.surface, fontWeight: FontWeight.bold, fontSize: Responsive.getDp(context, 12)),
            ),
            if (icon != null) ...[
              SizedBox(width: Responsive.getDp(context, 4)),
              Icon(
                icon,
                size: Responsive.getDp(context, 16),
                color: AppColors.surface,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
