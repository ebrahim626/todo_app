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

  Map<String, dynamic> toJson() => {
    'isSuccess': isSuccess,
    'message': message,
    'data': data.toJson(),
  };
}

class NotificationData {
  final List<AppNotification> notifications;
  final int totalUnreadCount;

  NotificationData({
    required this.notifications,
    required this.totalUnreadCount,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      notifications: (json['notifications'] as List<dynamic>? ?? [])
          .map((e) => AppNotification.fromJson(e))
          .toList(),
      totalUnreadCount: json['totalUnreadCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'notifications': notifications.map((e) => e.toJson()).toList(),
    'totalUnreadCount': totalUnreadCount,
  };
}

class AppNotification {
  final int id;
  final String title;
  final String body;
  final DateTime sentAt;
  final bool isRead;
  final int userId;
  final int? todoId;

  AppNotification({
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
      sentAt: DateTime.parse(json['sentAt']),
      isRead: json['isRead'] ?? false,
      userId: json['userId'] ?? 0,
      todoId: json['todoId'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'body': body,
    'sentAt': sentAt.toIso8601String(),
    'isRead': isRead,
    'userId': userId,
    'todoId': todoId,
  };

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
}