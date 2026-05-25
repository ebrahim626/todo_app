part of 'go_router.export.dart';

final navigatorKeyProvider = Provider<GlobalKey<NavigatorState>>(
  (ref) => GlobalKey<NavigatorState>(),
);

// final navigatorContextProvider = Provider<BuildContext?>((ref) {
//   final key = ref.watch(navigatorKeyProvider);
//   return key.currentContext;
// });

final goRouterProvider = Provider<GoRouter>((ref) {
  final navigatorKey = ref.watch(navigatorKeyProvider);
  return GoRouter(
    initialLocation: AppRoutes.splashScreenRoute,
    navigatorKey: navigatorKey,
    debugLogDiagnostics: true,
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.splashScreenRoute,
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
      GoRoute(
        path: AppRoutes.addTaskRoute,
        name: AddTaskScreen.name,
        builder: (_, __) => const AddTaskScreen(),
      ),


      // shell route for bottom navigation bar
      ShellRoute(
        builder: (context, state, child) => BottomNavBar(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.homeRoute,
            name: HomeScreen.name,
            builder: (_, __) => const HomeScreen(),
          ),
          GoRoute(
            path: AppRoutes.historyRoute,
            name: HistoryScreen.name,
            builder: (_, __) => const HistoryScreen(),
          ),
        ],
      ),
    ],
  );
});
