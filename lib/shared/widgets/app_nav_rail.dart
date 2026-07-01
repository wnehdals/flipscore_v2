import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

enum _NavItem {
  home('/'),
  usageTime('/usage-time'),
  settings('/settings');

  const _NavItem(this.path);
  final String path;
}

_NavItem _selectedFromLocation(String location) {
  // Reversed so '/usage-time' and '/settings' match before '/'
  for (final item in _NavItem.values.reversed) {
    if (location.startsWith(item.path)) return item;
  }
  return _NavItem.home;
}

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final selected = _selectedFromLocation(location);

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: Row(
            children: [
              _NavButton(
                icon: Icons.grid_view_rounded,
                label: '악보',
                selected: selected == _NavItem.home,
                onTap: () => context.go(_NavItem.home.path),
              ),
              _NavButton(
                icon: Icons.timer_outlined,
                label: '시간',
                selected: selected == _NavItem.usageTime,
                onTap: () => context.go(_NavItem.usageTime.path),
              ),
              _NavButton(
                icon: Icons.settings_outlined,
                label: '설정',
                selected: selected == _NavItem.settings,
                onTap: () => context.go(_NavItem.settings.path),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 22,
                color: selected ? AppColors.primary : AppColors.textTertiary,
              ),
              const SizedBox(height: 3),
              Text(
                label,
                style: AppTextStyles.micro.copyWith(
                  color: selected ? AppColors.primary : AppColors.textTertiary,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
