class UserProfileResponseModel {
  final bool isSuccess;
  final String message;
  final UserProfileModel data;

  UserProfileResponseModel({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory UserProfileResponseModel.fromJson(Map<String, dynamic> json) {
    return UserProfileResponseModel(
      isSuccess: json['isSuccess'] ?? false,
      message: json['message'] ?? '',
      data: UserProfileModel.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isSuccess': isSuccess,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class UserProfileModel {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String fcmToken;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProfileModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.fcmToken,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      fcmToken: json['fcmToken'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'fcmToken': fcmToken,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}