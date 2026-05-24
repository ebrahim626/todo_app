import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/database/hive_storage.dart';
import '../../../core/router/app_routers.dart';

typedef SplashScreenNotifier = AutoDisposeAsyncNotifierProviderFamily<SplashScreenProvider, void, BuildContext>;

final splashScreenProvider = SplashScreenNotifier(SplashScreenProvider.new);

class SplashScreenProvider extends AutoDisposeFamilyAsyncNotifier<void , BuildContext> {

  @override
  FutureOr<void> build(BuildContext arg) async {
    Future.delayed(const Duration(seconds: 3)).then((_) async {

      final store = ref.read(cacheServiceProvider);
      final isLoggedIn = await store.isLoggedIn;

      if (!arg.mounted) return; // Ensure the widget is still mounted before navigating

      if (isLoggedIn) {
        arg.go(AppRoutes.homeRoute);
      } else {
        arg.go(AppRoutes.getStartedRoute);
      }
    });

  }
}