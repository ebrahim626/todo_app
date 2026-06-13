import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/src/features/history/controller/history_provider.dart';
import 'package:todo_app/src/features/home/view/components/task_priority.dart';
import 'package:todo_app/src/features/add_task/model/request/create_task_request_model.dart';
import 'package:todo_app/src/features/add_task/repository/add_task_repository.dart';
import 'package:todo_app/src/features/home/controller/home_controller.dart';
import 'package:todo_app/src/shared/toast/toast.dart';

import '../../home/get_task_model/response/get_task_model.dart';

typedef AddTaskNotifier =
    AutoDisposeAsyncNotifierProviderFamily<AddTaskProvider, void, TodoModel?>;

final addTaskProvider = AddTaskNotifier(AddTaskProvider.new);

class AddTaskProvider extends AutoDisposeFamilyAsyncNotifier<void, TodoModel?> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  DateTime? selectedDueDate;
  DateTime? selectedReminderDate;
  List<String> taskTypes = [
    'Maintenance',
    'Work',
    'Personal',
    'Study',
    'Meeting',
    'Shopping',
    'Health',
    'Fitness',
    'Travel',
    'Finance',
    'Home',
    'Project',
    'Routine',
    'Appointment',
    'Research',
    'Family',
    'Self Care',
    'Cleaning',
    'Grocery',
    'Meditation',
    'Learning',
    'Reading',
    'Exercise',
    'Entertainment',
    'Social',
    'Other',
  ];

  List<String> taskPriorities = ['Must Do', 'Should Do', 'Can Wait'];

  String? selectedTaskType;
  String? selectedTaskPriority;
  TimeOfDay? selectedDueTime;
  TimeOfDay? selectedReminderTime;
  TextEditingController taskTitleController = TextEditingController();
  TextEditingController taskDescriptionController = TextEditingController();

  @override
  FutureOr<dynamic> build(TodoModel? arg) {
    if (arg != null) {
      taskTitleController.text = arg.title;
      taskDescriptionController.text = arg.description;
      selectedTaskType = arg.taskType;
      selectedTaskPriority = TaskPriority.getLabel(arg.taskPriority);
      selectedDueDate = arg.dueDate;
      selectedReminderDate = arg.reminderDate;
      if (selectedDueDate != null) {
        selectedDueTime =
            TimeOfDay(hour: selectedDueDate!.hour, minute: selectedDueDate!.minute);
      }
      if (selectedReminderDate != null) {
        selectedReminderTime = TimeOfDay(
            hour: selectedReminderDate!.hour, minute: selectedReminderDate!.minute);
      }
    }

  }

  void onDueDateChange(DateTime? date) {
    if (date != null) {
      selectedDueDate = DateTime(
        date.year,
        date.month,
        date.day,
        selectedDueTime?.hour ?? 0,
        selectedDueTime?.minute ?? 0,
      );

      ref.notifyListeners();
    }
  }

  void onReminderDateChange(DateTime? date) {
    if (date != null) {
      selectedReminderDate = DateTime(
        date.year,
        date.month,
        date.day,
        selectedReminderTime?.hour ?? 0,
        selectedReminderTime?.minute ?? 0,
      );

      ref.notifyListeners();
    }
  }

  void onTaskTypeChange(String? type) {
    if (type != null) {
      selectedTaskType = type;
      ref.notifyListeners();
    }
  }

  void onTaskPriorityChange(String? priority) {
    if (priority != null) {
      selectedTaskPriority = priority;
      ref.notifyListeners();
    }
  }

  void onDueTimeChange(TimeOfDay? time) {
    if (time != null) {
      selectedDueTime = time;

      if (selectedDueDate != null) {
        selectedDueDate = DateTime(
          selectedDueDate!.year,
          selectedDueDate!.month,
          selectedDueDate!.day,
          time.hour,
          time.minute,
        );
      }

      ref.notifyListeners();
    }
  }

  void onReminderTimeChange(TimeOfDay? time) {
    if (time != null) {
      selectedReminderTime = time;

      if (selectedReminderDate != null) {
        selectedReminderDate = DateTime(
          selectedReminderDate!.year,
          selectedReminderDate!.month,
          selectedReminderDate!.day,
          time.hour,
          time.minute,
        );
      }

      ref.notifyListeners();
    }
  }

  Future<void> addTask(BuildContext context, {required bool isUpdate}) async {
    try {
      if (!formKey.currentState!.validate()) {
        return;
      }
      if (selectedTaskType == null) {
        FlashCard.showError(errorMessage: "Please select a task type");
        return;
      }
      if (selectedTaskPriority == null) {
        FlashCard.showError(errorMessage: "Please select a task priority");
        return;
      }
      if (selectedDueDate == null) {
        FlashCard.showError(errorMessage: "Please select a due date");
        return;
      }
      if (selectedDueTime == null) {
        FlashCard.showError(errorMessage: "Please select a due time");
        return;
      }
      EasyLoading.show();
      ref.notifyListeners();

      final repo = ref.read(addTaskRepository);
      CreateTaskRequest createTaskRequest = CreateTaskRequest(
        title: taskTitleController.text,
        taskStatus: isUpdate ? arg?.taskStatus ?? 4 : 4, // Default to "Upcoming"
        taskPriority: TaskPriority.getValue(selectedTaskPriority ?? "") ?? 0,
        taskType: selectedTaskType ?? "",
        dueDate: selectedDueDate ?? DateTime.now(),
        reminderDate: selectedReminderDate ?? DateTime.now(),
        description: taskDescriptionController.text,
      );
      final response = isUpdate ? await repo.updateTask(createTaskModel: createTaskRequest, taskId: arg?.id ?? 0) : await repo.addTask(createTaskModel: createTaskRequest);
      if (response.statusCode == 200 || response.statusCode == 201) {
        FlashCard.showSuccess(message: "Task ${isUpdate ? "updated" : "added"} successfully");
        ref.invalidate(homeControllerProvider);
        ref.read(historyProvider.notifier).taskPagingController.refresh();
        ref.notifyListeners();
        context.pop();
      } else {
        log("Error ${isUpdate ? "updating" : "adding"} task: ${response.data}");
        FlashCard.showError(
          errorMessage: "Failed to ${isUpdate ? "update" : "add"}add task: ${response.data["message"]}",
        );
      }
    } catch (e) {
      log("Error adding task: $e");
    } finally {
      EasyLoading.dismiss();
    }
  }
}
