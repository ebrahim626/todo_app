import 'dart:async';
import 'dart:developer';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/src/features/notification/notification_model/response/Notification_response.dart';
import 'package:todo_app/src/features/notification/repository/notification_repository.dart';
import '../../../shared/toast/toast.dart';

typedef NotificationNotifier = AutoDisposeAsyncNotifierProvider<NotificationProvider, void>;

final notificationProvider = NotificationNotifier(NotificationProvider.new);

class NotificationProvider extends AutoDisposeAsyncNotifier {
  List<AppNotification>? appNotifications;

  @override
  FutureOr<dynamic> build() async {
    await getNotifications();
  }

  Future<void> getNotifications() async {
    try{
      EasyLoading.show();
      final repo = ref.read(notificationRepository);
      final response = await repo.getNotifications();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = NotificationResponse.fromJson(response.data);
        appNotifications = data.data.notifications;
      } else {
        FlashCard.showError(errorMessage: "Failed to fetch all notifications.");
      }

    }catch(e) {
      log("Error fetching notifications: $e");
      FlashCard.showError(
        errorMessage: "An error occurred while fetching notifications.",
      );
    }
    finally{
      EasyLoading.dismiss();
    }
  }

}