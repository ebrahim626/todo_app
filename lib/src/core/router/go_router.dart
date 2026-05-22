part of 'go_router.export.dart';

final goNavigatorKey = GlobalKey<NavigatorState>();

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.homeRoute,
    navigatorKey: goNavigatorKey,
    debugLogDiagnostics: true,
    routes: <RouteBase>[
      // GoRoute(
      //   path: AppRoutes.homeRoute,
      //   name: HomeScreen.name,
      //   builder: (_, state) => HomeScreen(),
      // ),
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
