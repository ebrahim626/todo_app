import 'package:todo_app/src/core/service/local_time_formatter.dart';

class CreateTaskRequest {
  final String title;
  final int taskStatus;
  final int taskPriority;
  final String taskType;
  final DateTime dueDate;
  final DateTime reminderDate;
  final String description;

  CreateTaskRequest({
    required this.title,
    required this.taskStatus,
    required this.taskPriority,
    required this.taskType,
    required this.dueDate,
    required this.reminderDate,
    required this.description,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'taskStatus': taskStatus,
    'taskPriority': taskPriority,
    'taskType': taskType,
    'dueDate': LocalTimeFormatter.toUtcIso(dueDate),           // ✅ keeps time
    'reminderDate': LocalTimeFormatter.toUtcIso(reminderDate), // ✅ keeps time
    'description': description,
  };
}