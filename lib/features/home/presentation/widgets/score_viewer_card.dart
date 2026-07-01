import 'package:flipscore/core/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/models/enums.dart';
import '../../../../shared/models/score_viewer.dart';

class ScoreViewerCard extends StatelessWidget {
  const ScoreViewerCard({
    super.key,
    required this.viewer,
    required this.onTap,
    this.onLongPress,
  });

  final ScoreViewer viewer;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(Responsive.getDp(context, 16)),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 썸네일 영역
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.badgeGesture,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(Responsive.getDp(context, 15))),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: SvgPicture.asset(
                        'assets/images/present_logo.svg',
                        width: Responsive.getDp(context, 48),
                        height: Responsive.getDp(context, 48)
                      ),
                    ),
                    // 페이지 수 배지
                    Positioned(
                      bottom: Responsive.getDp(context, 10),
                      right: Responsive.getDp(context, 10),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: Responsive.getDp(context, 8),
                          vertical: Responsive.getDp(context, 4),
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.dark.withValues(alpha: 0.65),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${viewer.pages.length}p',
                          style: AppTextStyles.micro.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // 메타 정보
            Padding(
              padding: EdgeInsets.fromLTRB(Responsive.getDp(context, 12), Responsive.getDp(context, 10), Responsive.getDp(context, 12), Responsive.getDp(context, 12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    viewer.title,
                    style: AppTextStyles.cardTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _ModeBadge(mode: viewer.transitionMode),
                      const Spacer(),
                      Text(
                        _formatDate(viewer.updatedAt),
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inDays == 0) return '오늘';
    if (diff.inDays == 1) return '어제';
    if (diff.inDays < 7) return '${diff.inDays}일 전';
    return '${dt.month}/${dt.day}';
  }
}

class _ModeBadge extends StatelessWidget {
  const _ModeBadge({required this.mode});
  final TransitionMode mode;

  @override
  Widget build(BuildContext context) {
    final (label, bg, fg) = switch (mode) {
      TransitionMode.song => (
        '노래',
        AppColors.badgeSong,
        AppColors.badgeSongText,
      ),
      TransitionMode.gesture => (
        '제스처',
        AppColors.badgeGesture,
        AppColors.badgeGestureText,
      ),
      TransitionMode.manual => (
        '수동',
        AppColors.badgeNone,
        AppColors.badgeNoneText,
      ),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(label, style: AppTextStyles.badge.copyWith(color: fg)),
    );
  }
}
