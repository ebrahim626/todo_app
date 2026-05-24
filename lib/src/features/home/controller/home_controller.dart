import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/src/core/database/hive_storage.dart';

typedef HomeControllerProvider = AutoDisposeAsyncNotifierProvider<HomeController, dynamic>;

final homeControllerProvider = HomeControllerProvider(HomeController.new);

class HomeController extends AutoDisposeAsyncNotifier {

  @override
  FutureOr<dynamic> build() {
  }

  // Future<void> logOut() async {
  //   ref.watch(cacheServiceProvider);
  //   await ref.read(cacheServiceProvider).refreshToken;
  // }

}