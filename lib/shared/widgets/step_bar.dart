import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class StepBar extends StatelessWidget {
  const StepBar({super.key, required this.step, required this.total});
  final int step;
  final int total;

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: step / total,
      backgroundColor: AppColors.border,
      valueColor: const AlwaysStoppedAnimation(AppColors.primary),
      minHeight: 3,
    );
  }
}
