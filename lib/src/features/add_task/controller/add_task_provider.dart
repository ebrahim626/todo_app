import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef AddTaskNotifier =
    AutoDisposeAsyncNotifierProvider<AddTaskProvider, void>;

final addTaskProvider = AddTaskNotifier(AddTaskProvider.new);

class AddTaskProvider extends AutoDisposeAsyncNotifier {
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
  String? selectedTaskType;
  String? selectedTaskPriority;

  @override
  FutureOr<dynamic> build() {}

  void onDueDateChange(DateTime? date) {
    if (date != null) {
      selectedDueDate = date;
      ref.notifyListeners();
    }
  }

  void onReminderDateChange(DateTime? date) {
    if (date != null) {
      selectedReminderDate = date;
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

}
