class TodoListResponse {
  final bool isSuccess;
  final String message;
  final TodoPaginationData data;

  TodoListResponse({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory TodoListResponse.fromJson(Map<String, dynamic> json) {
    return TodoListResponse(
      isSuccess: json['isSuccess'] ?? false,
      message: json['message'] ?? '',
      data: TodoPaginationData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {'isSuccess': isSuccess, 'message': message, 'data': data.toJson()};
  }
}

class TodoPaginationData {
  final int pageNumber;
  final int pageSize;
  final int totalPages;
  final int totalCount;
  final int totalUnreadCount;
  final List<TodoModel> data;

  TodoPaginationData({
    required this.pageNumber,
    required this.pageSize,
    required this.totalPages,
    required this.totalCount,
    required this.data,
    required this.totalUnreadCount,
  });

  factory TodoPaginationData.fromJson(Map<String, dynamic> json) {
    return TodoPaginationData(
      pageNumber: json['pageNumber'] ?? 0,
      pageSize: json['pageSize'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      totalCount: json['totalCount'] ?? 0,
      totalUnreadCount: json['totalUnreadCount'] ?? 0,
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => TodoModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pageNumber': pageNumber,
      'pageSize': pageSize,
      'totalPages': totalPages,
      'totalCount': totalCount,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class TodoModel {
  final int id;
  final int userId;
  final String title;
  final int taskStatus;
  final int taskPriority;
  final String taskType;
  final DateTime? dueDate;
  final DateTime? reminderDate;
  final String description;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  TodoModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.taskStatus,
    required this.taskPriority,
    required this.taskType,
    this.dueDate,
    this.reminderDate,
    required this.description,
    this.createdAt,
    this.updatedAt,
  });

  TodoModel copyWith({
    int? id,
    int? userId,
    String? title,
    int? taskStatus,
    int? taskPriority,
    String? taskType,
    DateTime? dueDate,
    DateTime? reminderDate,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TodoModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      taskStatus: taskStatus ?? this.taskStatus,
      taskPriority: taskPriority ?? this.taskPriority,
      taskType: taskType ?? this.taskType,
      dueDate: dueDate ?? this.dueDate,
      reminderDate: reminderDate ?? this.reminderDate,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      title: json['title'] ?? '',
      taskStatus: json['taskStatus'] ?? 0,
      taskPriority: json['taskPriority'] ?? 0,
      taskType: json['taskType'] ?? '',
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      reminderDate: json['reminderDate'] != null
          ? DateTime.parse(json['reminderDate'])
          : null,
      description: json['description'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'taskStatus': taskStatus,
      'taskPriority': taskPriority,
      'taskType': taskType,
      'dueDate': dueDate?.toIso8601String(),
      'reminderDate': reminderDate?.toIso8601String(),
      'description': description,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
