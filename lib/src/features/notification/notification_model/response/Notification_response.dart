class NotificationResponse {
  final bool isSuccess;
  final String message;
  final NotificationData data;

  NotificationResponse({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    return NotificationResponse(
      isSuccess: json['isSuccess'] ?? false,
      message: json['message'] ?? '',
      data: NotificationData.fromJson(json['data'] ?? {}),
    );
  }
}

class NotificationData {
  final int pageNumber;
  final int pageSize;
  final int totalPages;
  final int totalCount;
  final int totalUnreadCount;
  final List<AppNotification> notifications;

  NotificationData({
    required this.pageNumber,
    required this.pageSize,
    required this.totalPages,
    required this.totalCount,
    required this.totalUnreadCount,
    required this.notifications,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      pageNumber: json['pageNumber'] ?? 1,
      pageSize: json['pageSize'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      totalCount: json['totalCount'] ?? 0,
      totalUnreadCount: json['totalUnreadCount'] ?? 0,
      notifications: (json['data'] as List<dynamic>? ?? [])
          .map((e) => AppNotification.fromJson(e))
          .toList(),
    );
  }
}

class AppNotification {
  final int id;
  final String title;
  final String body;
  final DateTime? sentAt;
  final bool isRead;
  final int userId;
  final int? todoId;

  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.sentAt,
    required this.isRead,
    required this.userId,
    this.todoId,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      sentAt: json['sentAt'] != null
          ? DateTime.tryParse(json['sentAt'])
          : null,
      isRead: json['isRead'] ?? false,
      userId: json['userId'] ?? 0,
      todoId: json['todoId'],
    );
  }

  AppNotification copyWith({
    int? id,
    String? title,
    String? body,
    DateTime? sentAt,
    bool? isRead,
    int? userId,
    int? todoId,
  }) {
    return AppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      sentAt: sentAt ?? this.sentAt,
      isRead: isRead ?? this.isRead,
      userId: userId ?? this.userId,
      todoId: todoId ?? this.todoId,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'body': body,
    'sentAt': sentAt?.toIso8601String(),
    'isRead': isRead,
    'userId': userId,
    'todoId': todoId,
  };
}