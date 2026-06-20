import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:todo_app/src/core/config/constant/app_constants.dart';
import 'package:todo_app/src/core/config/size/size.dart';
import 'package:todo_app/src/core/router/go_router.export.dart';
import 'package:todo_app/src/core/service/firebase_messaging_service.dart';
import 'package:todo_app/src/core/service/notification_service.dart';
import 'package:todo_app/src/core/utils/extensions/context.dart';
import 'package:todo_app/src/core/utils/theme/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todo_app/src/features/common/view/easy_loading_color_ring/AnimatedDualColorRing.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Hive service
  await Hive.initFlutter();
  await Hive.openBox<dynamic>(AppConstants.hiveKey);

  //Local Notifications
  final localNotificationService = LocalNotificationsService.instance();
  await localNotificationService.init();
  final container = ProviderContainer(); // 👈

  // Firebase Messaging (Depends on notifications service)
  final firebaseMessagingService = FirebaseMessagingService.instance();
  firebaseMessagingService.init(
    localNotificationsService: localNotificationService,
    container: container,
  );

  await ScreenUtil.ensureScreenSize();

  runApp(UncontrolledProviderScope(container: container, child: const MyApp()));
}

void configEasyLoading(BuildContext context) {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 60.0
    ..radius = 16.0
    ..progressColor = Colors.transparent
    ..backgroundColor = Colors.transparent
    ..indicatorColor = Colors.transparent
    ..textColor = Colors.transparent
    // ..maskColor = Colors.black.withOpacity(0.3)
    ..maskColor = Colors.black
        .withAlpha(
          20,
        ) // Very light mask for better visibility of the rotating ring, but still prevents interactions
    ..maskType = EasyLoadingMaskType.custom
    ..userInteractions = false
    ..dismissOnTap = false
    ..indicatorWidget = _buildLoadingWidget()
    ..boxShadow = <BoxShadow>[];
}

Widget _buildLoadingWidget() {
  return SizedBox(
    width: 100,
    height: 100,
    child: Stack(
      alignment: Alignment.center,
      children: [
        // 🔄 Rotating ring
        AnimatedDualColorRing(),

        // 🏷️ Force logo to exact center
        Positioned.fill(
          top: 2,
          child: Center(
            child: Image.asset(
              'assets/images/todo_loading.png',
              width: 65,
              height: 65,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      useInheritedMediaQuery: true,
      builder: (context, child) {
        return MaterialApp.router(
          routerConfig: ref.watch(goRouterProvider),
          title: 'Todo App',
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          builder: EasyLoading.init(
            builder: (context, child) {
              configEasyLoading(context);
              topBarSize = context.padding.top;
              bottomViewPadding = context.padding.bottom;
              return MediaQuery(
                data: context.mq.copyWith(
                  devicePixelRatio: 1.0,
                  textScaler: const TextScaler.linear(1.0),
                ),
                child: child!,
              );
            },
          ),
          // home: const GetStartedScreen(),
        );
      },
    );
  }
}
