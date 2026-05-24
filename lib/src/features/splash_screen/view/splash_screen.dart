import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/src/features/splash_screen/controller/splash_provider.dart';
import '../../../core/utils/theme/theme.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

    static const String name = 'splash_screen';

    @override
    Widget build(BuildContext context, WidgetRef ref) {
      ref.watch(splashScreenProvider(context));
      ref.read(splashScreenProvider(context).notifier);
      return Scaffold(
        backgroundColor: backgroundColor,
        body: Center(
          child: Image.asset(
            'assets/images/todo_logo.png',
            width: 100,
            height: 100,
          ),
        ),
      );
    }
}
