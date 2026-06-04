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
    'dueDate': dueDate.toUtc().toIso8601String(),
    'reminderDate': reminderDate.toUtc().toIso8601String(),
    'description': description,
  };
}