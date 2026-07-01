import 'package:flutter/material.dart';
import 'app_colors.dart';

abstract final class AppTextStyles {
  static const _base = TextStyle(
    fontFamily: 'Pretendard Variable',
    color: AppColors.textPrimary,
    letterSpacing: 0,
  );

  static final headline = _base.copyWith(fontSize: 30, fontWeight: FontWeight.w800, letterSpacing: -0.7);
  static final title = _base.copyWith(fontSize: 21, fontWeight: FontWeight.w800, letterSpacing: -0.5);
  static final subtitle = _base.copyWith(fontSize: 17, fontWeight: FontWeight.w700);
  static final cardTitle = _base.copyWith(fontSize: 15, fontWeight: FontWeight.w700, letterSpacing: -0.2);
  static final body = _base.copyWith(fontSize: 14, fontWeight: FontWeight.w400);
  static final bodyMedium = _base.copyWith(fontSize: 14, fontWeight: FontWeight.w600);
  static final bodySmall = _base.copyWith(fontSize: 13.5, fontWeight: FontWeight.w400);
  static final label = _base.copyWith(fontSize: 13, fontWeight: FontWeight.w600);
  static final caption = _base.copyWith(fontSize: 12.5, fontWeight: FontWeight.w400, color: AppColors.textTertiary);
  static final captionBold = _base.copyWith(fontSize: 12.5, fontWeight: FontWeight.w700);
  static final micro = _base.copyWith(fontSize: 12, fontWeight: FontWeight.w600);
  static final badge = _base.copyWith(fontSize: 11.5, fontWeight: FontWeight.w700);
  static final playerTime = _base.copyWith(fontSize: 13, fontWeight: FontWeight.w600, fontFeatures: [const FontFeature.tabularFigures()]);
}
