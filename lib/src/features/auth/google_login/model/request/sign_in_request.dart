class SignInRequest {
  final String firebaseToken;
  final String fcmToken;

  SignInRequest({
    required this.firebaseToken,
    required this.fcmToken,
  });

  Map<String, dynamic> toJson() {
    return {
      'firebaseToken': firebaseToken,
      'fcmToken': fcmToken,
    };
  }
}