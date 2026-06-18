import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/database/hive_storage.dart';
import '../../../core/router/app_routers.dart';

enum Menu { taskCalender, history, profile, logout,}

typedef MenuNotifier = AsyncNotifierProvider<MenuProvider, void>;

final menuProvider = MenuNotifier(MenuProvider.new);

class MenuProvider extends AsyncNotifier {
  late Menu selectedMenu;

  @override
  FutureOr<dynamic> build() {
    selectedMenu = Menu.taskCalender;
  }

  void onMenuTap(Menu menu) {
    selectedMenu = menu;
    ref.notifyListeners();
  }

  Future<void> logOut(BuildContext context) async {
    ref.watch(cacheServiceProvider);
    await ref.read(cacheServiceProvider).clearAuthTokens();
    context.push(AppRoutes.splashScreenRoute);
  }

}
