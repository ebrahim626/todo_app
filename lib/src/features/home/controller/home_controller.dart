import 'dart:async';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/src/core/database/hive_storage.dart';
import 'package:todo_app/src/core/router/app_routers.dart';
import 'package:todo_app/src/features/home/get_task_model/response/get_task_model.dart';
import 'package:todo_app/src/features/home/repository/home_repository.dart';
import 'package:todo_app/src/shared/toast/toast.dart';

import '../../../core/utils/theme/theme.dart';

typedef HomeControllerProvider = AutoDisposeAsyncNotifierProvider<HomeController, dynamic>;

final homeControllerProvider = HomeControllerProvider(HomeController.new);

class HomeController extends AutoDisposeAsyncNotifier {

  List<TodoModel>? todoTasks;

  @override
  FutureOr<dynamic> build() async {
     await getTasks();
  }

  Color getStatusColor(int status) {
    switch (status) {
      case 1:
        return primaryColor;
      case 2:
        return closedColor;
      case 3:
        return pendingColor;
      case 4:
        return upcomingColor;
      default:
        return Colors.grey;
    }
  }

  Future<void> logOut(BuildContext context) async {
    ref.watch(cacheServiceProvider);
    await ref.read(cacheServiceProvider).clearAuthTokens();
    context.push(AppRoutes.splashScreenRoute);
  }

  Future<void> refresh({DateTime? date}) async {
    await getTasks(date: date);
  }

  FutureOr<void> getTasks({DateTime? date}) async {
    try{
      EasyLoading.show();
      ref.notifyListeners();

      final repoData = ref.read(homeRepository);

      ///"reminderDate": "2026-06-03T14:52:12.312Z",
      final response = await repoData.getAllTasks(date: date?.toUtc().toIso8601String() ?? DateTime.now().toUtc().toIso8601String());

      if ( response.statusCode == 200 ) {
        // Handle successful response
        final  data = TodoListResponse.fromJson(response.data);
        todoTasks = data.data.data;

      } else {
        // Handle non-successful response
      FlashCard.showError(errorMessage: "Failed to fetch tasks.");
      }
    }catch(e){
      log("Error fetching tasks: $e");
      FlashCard.showError(errorMessage: "An error occurred while fetching tasks.");
    }
    finally {
      EasyLoading.dismiss();
      ref.notifyListeners();
    }
  }

}