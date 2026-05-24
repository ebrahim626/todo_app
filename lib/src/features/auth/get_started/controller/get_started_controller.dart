import 'dart:async';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/database/hive_storage.dart';
import '../../../../core/router/app_routers.dart';

typedef GetStartedNotifier = AutoDisposeNotifierProviderFamily<GetStartedProvider, void, BuildContext>;

final getStartedProvider = GetStartedNotifier(GetStartedProvider.new);

class GetStartedProvider extends AutoDisposeFamilyNotifier<void, BuildContext> {

  @override
  FutureOr build(arg) async {
    EasyLoading.show();
    // Watch the isLoggedInProvider instead of reading directly
    final isLoggedInAsync = ref.watch(isLoggedInProvider);

    // Navigate if already logged in
    isLoggedInAsync.when(
      data: (isLoggedIn) {
        if (isLoggedIn == true) {
          arg.go(AppRoutes.homeRoute);
        }
      },
      error: (error, stack) {
        log('Error checking login status: $error');
      },
      loading: () {
        // Optional: Show loading indicator
        log('Checking login status...');
      },
    );
    EasyLoading.dismiss();
  }
}