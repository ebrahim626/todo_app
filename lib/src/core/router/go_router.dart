part of 'go_router.export.dart';

final goNavigatorKey = GlobalKey<NavigatorState>();

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splashScreenRoute, // 👈 start here
    navigatorKey: goNavigatorKey,
    debugLogDiagnostics: true,
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.splashScreenRoute,        // 👈 add this
        name: SplashScreen.name,
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.getStartedRoute,
        name: GetStartedScreen.name,
        builder: (_, __) => const GetStartedScreen(),
      ),
      GoRoute(
        path: AppRoutes.getStartedRoute,
        name: GoogleLoginScreen.name,
        builder: (_, __) => const GoogleLoginScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => BottomNavBar(child: child),
        routes: [
          GoRoute(path: AppRoutes.homeRoute, name: HomeScreen.name, builder: (_, __) => const HomeScreen()),
          GoRoute(path: AppRoutes.historyRoute, name: HistoryScreen.name, builder: (_, __) => const HistoryScreen()),
        ],
      ),
    ],
  );
});
