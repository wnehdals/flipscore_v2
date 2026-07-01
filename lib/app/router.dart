import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/providers/auth_provider.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/onboarding_screen.dart';
import '../features/auth/presentation/screens/privacy_policy_screen.dart';
import '../features/auth/presentation/screens/terms_screen.dart';
import '../features/create/presentation/screens/create_gesture_screen.dart';
import '../features/create/presentation/screens/create_mode_screen.dart';
import '../features/create/presentation/screens/create_scores_screen.dart';
import '../features/create/presentation/screens/create_song_screen.dart';
import '../features/create/presentation/screens/create_timeline_screen.dart';
import '../features/home/presentation/screens/home_screen.dart';
import '../features/settings/presentation/screens/settings_screen.dart';
import '../features/usage_time/presentation/screens/usage_time_screen.dart';
import '../features/viewer/presentation/screens/viewer_screen.dart';
import '../features/viewer/presentation/screens/viewer_timeline_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = _AuthChangeNotifier();

  ref.listen(authStateProvider, (prev, next) {
    notifier.notifyListeners();
  });

  ref.onDispose(() => notifier.dispose());

  return GoRouter(
    initialLocation: '/login',
    refreshListenable: notifier,
    redirect: (context, state) {
      final authAsync = ref.read(authStateProvider);

      if (authAsync.isLoading) return null;

      final isLoggedIn = authAsync.valueOrNull != null;
      final loc = state.matchedLocation;

      const publicRoutes = ['/login', '/terms', '/privacy-policy'];
      if (!isLoggedIn && !publicRoutes.contains(loc)) return '/login';
      if (isLoggedIn && loc == '/login') return '/';
      return null;
    },
    routes: [
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

      // 이용시간 (Phase 5)
      GoRoute(
        path: '/usage-time',
        builder: (context, state) => const UsageTimeScreen(),
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
