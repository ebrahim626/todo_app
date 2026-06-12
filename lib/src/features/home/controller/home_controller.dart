import 'dart:async';
import 'dart:developer';
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
import '../../add_task/model/request/create_task_request_model.dart';
import '../../add_task/repository/add_task_repository.dart';

typedef HomeControllerProvider =
    AutoDisposeAsyncNotifierProvider<HomeController, dynamic>;

final homeControllerProvider = HomeControllerProvider(HomeController.new);

class HomeController extends AutoDisposeAsyncNotifier {
  List<TodoModel>? todoTasks;
  List<TodoModel>? allTodoTasks;
  DateTime selectedDate = DateTime.now();

  @override
  FutureOr<dynamic> build() async {
    await initial();
  }

  Future<void> initial() async {
    try {
      EasyLoading.show();
      await Future.wait([getAllTasks(), getTasks()]);
    } catch (e) {
      log("Error during initial data fetch: $e");
    } finally {
      EasyLoading.dismiss();
    }
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

  // Add this getter to build the color map
  Map<DateTime, List<Color>> get taskColorMap {
    final Map<DateTime, List<Color>> colorMap = {};

    for (final task in allTodoTasks ?? []) {
      if (task.dueDate == null) continue;

      final localDate = task.dueDate!.toLocal();

      final key = DateTime(localDate.year, localDate.month, localDate.day);

      final color = getStatusColor(task.taskStatus ?? 1);

      if (colorMap.containsKey(key)) {
        if (!colorMap[key]!.contains(color)) {
          colorMap[key]!.add(color);
        }
      } else {
        colorMap[key] = [color];
      }
    }

    return colorMap;
  }

  // Add this helper
  List<Color> getColorsForDay(DateTime day) {
    final key = DateTime(day.year, day.month, day.day);
    return taskColorMap[key] ?? [];
  }

  Future<void> logOut(BuildContext context) async {
    ref.watch(cacheServiceProvider);
    await ref.read(cacheServiceProvider).clearAuthTokens();
    context.push(AppRoutes.splashScreenRoute);
  }

  Future<void> refresh({DateTime? date}) async {
    selectedDate = DateTime.now();
    await initial();
  }

  Future<void> getTasks({DateTime? date, bool isFirstLoad = true}) async {
    try {
      ref.notifyListeners();
      isFirstLoad == false ? EasyLoading.show() : null;

      final repoData = ref.read(homeRepository);

      ///"reminderDate": "2026-06-03T14:52:12.312Z",
      final response = await repoData.getAllTasks(date: date ?? DateTime.now());

      if (response.statusCode == 200) {
        // Handle successful response
        final data = TodoListResponse.fromJson(response.data);
        todoTasks = data.data.data;
      } else {
        // Handle non-successful response
        FlashCard.showError(errorMessage: "Failed to fetch tasks.");
      }
    } catch (e) {
      log("Error fetching tasks: $e");
      FlashCard.showError(
        errorMessage: "An error occurred while fetching tasks.",
      );
    } finally {
      isFirstLoad == false ? EasyLoading.dismiss() : null;
      ref.notifyListeners();
    }
  }

  Future<void> getAllTasks() async {
    try {
      final repoData = ref.read(homeRepository);

      final allResponse = await repoData.getAllTasks();

      if (allResponse.statusCode == 200) {
        final allData = TodoListResponse.fromJson(allResponse.data);
        allTodoTasks = allData.data.data;
      } else {
        FlashCard.showError(errorMessage: "Failed to fetch all tasks.");
      }
    } catch (e) {
      log("Error fetching tasks: $e");
      FlashCard.showError(
        errorMessage: "An error occurred while fetching tasks.",
      );
    } finally {
      ref.notifyListeners();
    }
  }

  Future<void> updateStatus(
    BuildContext context, {
    required TodoModel task,
    required int taskStatus,
  }) async {
    try {

      final repo = ref.read(addTaskRepository);
      CreateTaskRequest createTaskRequest = CreateTaskRequest(
        title: task.title,
        taskStatus: taskStatus, // Changing task status
        taskPriority: task.taskPriority,
        taskType: task.taskType,
        dueDate: task.dueDate ?? DateTime.now(),
        reminderDate: task.reminderDate ?? DateTime.now(),
        description: task.description,
      );
      final response = await repo.updateTask(
        createTaskModel: createTaskRequest,
        taskId: task.id,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        FlashCard.showSuccess(
          message: taskStatus == 1
              ? "Mark as done successfully"
              : "Mark as closed successfully",
        );
        final index = todoTasks?.indexWhere((t) => t.id == task.id);
        if(index == null) return; // ✅ returns when NOT found
        todoTasks?[index] = todoTasks![index].copyWith(taskStatus: taskStatus);

        final indexAll = allTodoTasks?.indexWhere((t) => t.id == task.id);
        if (indexAll == null) return; // ✅ returns when NOT found
        allTodoTasks?[indexAll] = allTodoTasks![indexAll].copyWith(taskStatus: taskStatus);
        ref.notifyListeners();
      } else {
        log("Error updating task: ${response.data}");
        FlashCard.showError(
          errorMessage: "Failed to update task: ${response.data["message"]}",
        );
      }
    } catch (e) {
      log("Error updating task: $e");
    }
  }

  Future<void> deleteTask(
      BuildContext context, {
        required int taskId,
      }) async {
    try {
      EasyLoading.show();
      final repo = ref.read(addTaskRepository);
      final response = await repo.deleteTask(
        taskId: taskId,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        FlashCard.showSuccess(message: "Task deleted successfully");

        // Remove from todoTasks
        final index = todoTasks?.indexWhere((t) => t.id == taskId);
        if (index == null || index == -1) return;
        todoTasks?.removeAt(index); // ✅ just remove

        final indexAll = allTodoTasks?.indexWhere((t) => t.id == taskId);
        if (indexAll == null) return; // ✅ returns when NOT found
        allTodoTasks?.removeAt(index);
        ref.notifyListeners();
        context.pop();
      } else {
        log("Error updating task: ${response.data}");
        FlashCard.showError(
          errorMessage: "Failed to update task: ${response.data["message"]}",
        );
      }
    } catch (e) {
      log("Error updating task: $e");
    }finally{
      EasyLoading.dismiss();
    }
  }

}
