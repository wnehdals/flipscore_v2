import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/providers/auth_provider.dart';
import '../features/auth/presentation/providers/permission_notice_provider.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/onboarding_screen.dart';
import '../features/auth/presentation/screens/permission_notice_screen.dart';
import '../features/auth/presentation/screens/privacy_policy_screen.dart';
import '../features/auth/presentation/screens/terms_screen.dart';
import '../features/create/presentation/screens/create_gesture_screen.dart';
import '../features/create/presentation/screens/create_mode_screen.dart';
import '../features/create/presentation/screens/create_scores_screen.dart';
import '../features/create/presentation/screens/create_song_screen.dart';
import '../features/create/presentation/screens/create_timeline_screen.dart';
import '../features/force_update/presentation/providers/force_update_provider.dart';
import '../features/force_update/presentation/screens/force_update_screen.dart';
import '../features/home/presentation/screens/home_screen.dart';
import '../features/settings/presentation/screens/settings_screen.dart';
import '../features/viewer/presentation/screens/viewer_screen.dart';
import '../features/viewer/presentation/screens/viewer_timeline_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = _AuthChangeNotifier();

  ref.listen(authStateProvider, (prev, next) {
    notifier.notifyListeners();
  });
  ref.listen(permissionNoticeSeenProvider, (prev, next) {
    notifier.notifyListeners();
  });
  ref.listen(forceUpdateCheckProvider, (prev, next) {
    notifier.notifyListeners();
  });

  ref.onDispose(() => notifier.dispose());

  return GoRouter(
    initialLocation: '/login',
    refreshListenable: notifier,
    redirect: (context, state) {
      final loc = state.matchedLocation;

      final authAsync = ref.read(authStateProvider);
      if (authAsync.isLoading) return null;
      final isLoggedIn = authAsync.valueOrNull != null;

      final forceUpdateAsync = ref.read(forceUpdateCheckProvider);
      if (forceUpdateAsync.isLoading) return null;

      final forceUpdate = forceUpdateAsync.valueOrNull;
      // 스토어 심사 정책상 이용약관/개인정보처리방침은 강제 업데이트 중에도 열람 가능해야 함.
      const legalRoutes = ['/terms', '/privacy-policy'];
      if (forceUpdate != null &&
          forceUpdate.isRequired &&
          !legalRoutes.contains(loc)) {
        return loc == '/force-update' ? null : '/force-update';
      }
      if (loc == '/force-update') return isLoggedIn ? '/' : '/login';

      final noticeAsync = ref.read(permissionNoticeSeenProvider);
      if (noticeAsync.isLoading) return null;

      final hasSeenNotice = noticeAsync.valueOrNull ?? false;
      if (!hasSeenNotice) {
        return loc == '/permission-notice' ? null : '/permission-notice';
      }

      if (loc == '/permission-notice') return isLoggedIn ? '/' : '/login';

      const publicRoutes = ['/login', '/terms', '/privacy-policy'];
      if (!isLoggedIn && !publicRoutes.contains(loc)) return '/login';
      if (isLoggedIn && loc == '/login') return '/';
      return null;
    },
    routes: [
      GoRoute(
        path: '/force-update',
        builder: (context, state) => const ForceUpdateScreen(),
      ),
      GoRoute(
        path: '/permission-notice',
        builder: (context, state) => const PermissionNoticeScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/terms',
        builder: (context, state) => const TermsScreen(),
      ),
      GoRoute(
        path: '/privacy-policy',
        builder: (context, state) => const PrivacyPolicyScreen(),
      ),

      // 악보뷰어 생성 플로우 (Phase 3)
      GoRoute(
        path: '/create/scores',
        builder: (context, state) => const CreateScoresScreen(),
      ),
      GoRoute(
        path: '/create/mode',
        builder: (context, state) => const CreateModeScreen(),
      ),
      GoRoute(
        path: '/create/song',
        builder: (context, state) => const CreateSongScreen(),
      ),
      GoRoute(
        path: '/create/timeline',
        builder: (context, state) => const CreateTimelineScreen(),
      ),
      GoRoute(
        path: '/create/gesture',
        builder: (context, state) => const CreateGestureScreen(),
      ),

      // 악보뷰어 실행 (Phase 4)
      GoRoute(
        path: '/viewer/:id',
        builder: (context, state) => ViewerScreen(
          viewerId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/viewer/:id/timeline',
        builder: (context, state) => ViewerTimelineScreen(
          viewerId: state.pathParameters['id']!,
        ),
      ),


      // 설정 (Phase 6)
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
});

class _AuthChangeNotifier extends ChangeNotifier {
  @override
  void notifyListeners() => super.notifyListeners();
}
