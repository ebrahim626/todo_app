import 'dart:async';
import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/theme/theme.dart';
import '../../../shared/toast/toast.dart';
import '../../home/get_task_model/response/get_task_model.dart';
import '../../home/repository/home_repository.dart';

typedef HistoryNotifier = AutoDisposeAsyncNotifierProvider<HistoryProvider,void>;

final historyProvider = HistoryNotifier(HistoryProvider.new);

class HistoryProvider extends AutoDisposeAsyncNotifier {

  List<TodoModel>? allTodoTasks;

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

  FutureOr<void> getTasks({DateTime? date}) async {
    try{
      EasyLoading.show();
      ref.notifyListeners();

      final repoData = ref.read(homeRepository);

      final allResponse = await repoData.getAllTasks();

      if(allResponse.statusCode == 200){
        final allData = TodoListResponse.fromJson(allResponse.data);
        allTodoTasks = allData.data.data;
      } else {
        FlashCard.showError(errorMessage: "Failed to fetch all tasks.");
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