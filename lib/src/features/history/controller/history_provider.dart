import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:todo_app/src/features/history/repository/history_repository.dart';
import 'package:todo_app/src/features/home/view/components/task_priority.dart';
import 'package:todo_app/src/features/home/view/components/task_status.dart';
import '../../../core/utils/theme/theme.dart';
import '../../../shared/toast/toast.dart';
import '../../add_task/model/request/create_task_request_model.dart';
import '../../add_task/repository/add_task_repository.dart';
import '../../home/get_task_model/response/get_task_model.dart';

typedef HistoryNotifier = AsyncNotifierProvider<HistoryProvider, void>;
final historyProvider = HistoryNotifier(HistoryProvider.new);

class HistoryProvider extends AsyncNotifier {
  final PagingController<int, TodoModel> taskPagingController =
      PagingController(firstPageKey: 1);
  int? selectedTaskStatus;
  String? dropDownLabel;
  int? selectedTaskPriority;
  String? dropDownPriorityLabel;
  bool isStatusMenuOpen = false;
  bool isPriorityMenuOpen = false;
  List<String> priorityList = ['Must Do', 'Should Do', 'Can Wait'];
  final defaultPriorityList = ['Must Do', 'Should Do', 'Can Wait'];
  List<String> taskStatusList = ['Done', 'Closed', 'Pending', 'Upcoming'];
  final defaultStatusList = ['Done', 'Closed', 'Pending', 'Upcoming'];

  @override
  FutureOr<dynamic> build() async {
    log("BUILD CALLED");

    ref.onDispose(() => taskPagingController.dispose());

    taskPagingController.addPageRequestListener((pageKey) async {
      log("PAGE REQUEST: $pageKey");
      if (selectedTaskStatus != null || selectedTaskPriority != null) {
        await viewByStatus(page: pageKey, taskStatus: selectedTaskStatus, taskPriority: selectedTaskPriority);
      } else {
        await getTasksHistory(page: pageKey);
      }
    });
  }

  void setStatusMenuState(bool value) {
    isStatusMenuOpen = value;
    ref.notifyListeners();
  }
  void setPriorityMenuState(bool value) {
    isPriorityMenuOpen = value;
    ref.notifyListeners();
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

  Future<void> refresh() async {
    taskPagingController.refresh(); // triggers pageRequestListener → API call
  }

  FutureOr<void> getTasksHistory({required int page, int pageSize = 10}) async {
    try {
      final repoData = ref.read(historyRepository);

      final allResponse = await repoData.getHistoryTasks(
        page: page,
        pageSize: pageSize,
      );

      if (allResponse.statusCode == 200) {
        final data = TodoListResponse.fromJson(allResponse.data);
        final newItems = data.data.data;
        final isLastPage = newItems.length < pageSize;

        if (isLastPage) {
          taskPagingController.appendLastPage(newItems);
        } else {
          final nextPageKey = page + 1;
          taskPagingController.appendPage(newItems, nextPageKey);
        }
      } else {
        FlashCard.showError(errorMessage: "Failed to fetch history tasks.");
      }
    } catch (e) {
      log("Error fetching tasks: $e");
      FlashCard.showError(
        errorMessage: "An error occurred while fetching tasks.",
      );
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

        final updatedHistory = taskPagingController.itemList?.map((t) {
          return t.id == task.id ? t.copyWith(taskStatus: taskStatus) : t;
        }).toList();
        if (updatedHistory != null) {
          taskPagingController.itemList = updatedHistory;
        }
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

  Future<void> deleteTask(BuildContext context, {required int taskId}) async {
    try {
      EasyLoading.show();
      final repo = ref.read(addTaskRepository);
      final response = await repo.deleteTask(taskId: taskId);
      if (response.statusCode == 200 || response.statusCode == 201) {
        FlashCard.showSuccess(message: "Task deleted successfully");

        // Remove from paged list
        final updatedItems = taskPagingController.itemList
            ?.where((t) => t.id != taskId)
            .toList();

        if (updatedItems != null) {
          taskPagingController.itemList = updatedItems;
        }
        ref.notifyListeners();
        context.pop();
      } else {
        log("Error updating task: ${response.data}");
        FlashCard.showError(
          errorMessage: "Failed to update task: ${response.data["message"]}",
        );
      }
    } catch (e) {
      log("Error deleting tasks: $e");
      FlashCard.showError(
        errorMessage: "An error occurred while deleting tasks.",
      );
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> viewByStatus({
    required int page,
    int pageSize = 10,
    int? taskStatus,
    int? taskPriority
  }) async {
    try {
      final repo = ref.read(historyRepository);
      final response = await repo.getHistoryTasks(
        pageSize: pageSize,
        page: page,
        taskStatus: taskStatus,
        taskPriority: taskPriority,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = TodoListResponse.fromJson(response.data);
        final newItems = data.data.data;
        final isLastPage = newItems.length < pageSize;

        if (isLastPage) {
          taskPagingController.appendLastPage(newItems);
        } else {
          taskPagingController.appendPage(newItems, page + 1);
        }
      }
    } catch (e) {
      log("Error updating status : $e");
      FlashCard.showError(
        errorMessage: "An error occurred while updating status.",
      );
    }
  }

  Future<void> filterByStatus(String label) async {
    if (label == 'All') {
      taskStatusList = List.from(defaultStatusList);
      dropDownLabel = null;
    } else {
      dropDownLabel = label;

      taskStatusList = List.from(defaultStatusList);
      taskStatusList.remove(label);
      taskStatusList.insert(0, 'All');
    }
    isStatusMenuOpen = false;
    selectedTaskStatus = TaskStatus.getValue(label);

    ref.notifyListeners();
    taskPagingController.itemList = [];
    taskPagingController.refresh();
  }

  Future<void> filterByPriority(String label) async {
    if (label == 'All') {
      priorityList = List.from(defaultPriorityList);
      dropDownPriorityLabel = null;
    } else {
      dropDownPriorityLabel = label;

      priorityList = List.from(defaultPriorityList);
      priorityList.remove(label);
      priorityList.insert(0, 'All');
    }
    isPriorityMenuOpen = false;
    selectedTaskPriority = TaskPriority.getValue(label);

    ref.notifyListeners();
    taskPagingController.itemList = [];
    taskPagingController.refresh();
  }
}
