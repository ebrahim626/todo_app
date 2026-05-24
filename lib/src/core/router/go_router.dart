part of 'go_router.export.dart';

final goNavigatorKey = GlobalKey<NavigatorState>();

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.getStartedRoute,
    navigatorKey: goNavigatorKey,
    debugLogDiagnostics: true,
    routes: <RouteBase>[
      // GoRoute(
      //   path: AppRoutes.homeRoute,
      //   name: HomeScreen.name,
      //   builder: (_, state) => HomeScreen(),
      // ),
      GoRoute(
        path: AppRoutes.getStartedRoute,
        name: GetStartedScreen.name,
        builder: (context, state) => GetStartedScreen(),
      ),
      GoRoute(
        path: AppRoutes.splashScreenRoute,
        name: GoogleLoginScreen.name,
        builder: (context, state) => GoogleLoginScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return BottomNavBar(child: child);
        },
        routes: [
          GoRoute(path: AppRoutes.homeRoute, name: HomeScreen.name, builder: (_, __) => const HomeScreen()),

          GoRoute(path: AppRoutes.historyRoute, name: HistoryScreen.name, builder: (_, __) => const HistoryScreen()),

        ],
      ),
    ],
  );
});
