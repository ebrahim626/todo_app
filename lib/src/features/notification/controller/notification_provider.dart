import 'dart:async';
import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:todo_app/src/features/notification/notification_model/response/Notification_response.dart';
import 'package:todo_app/src/features/notification/repository/notification_repository.dart';
import '../../../shared/toast/toast.dart';

typedef NotificationNotifier =
    AutoDisposeAsyncNotifierProvider<NotificationProvider, void>;

final notificationProvider = NotificationNotifier(NotificationProvider.new);

class NotificationProvider extends AutoDisposeAsyncNotifier {

  int? unReadNotifications;
  final PagingController<int, AppNotification> notificationPagingController =
      PagingController(firstPageKey: 1);

  @override
  FutureOr<dynamic> build() async {
    notificationPagingController.addPageRequestListener((pageKey) async {
      await getNotifications(pageKey);
    });
  }

  Future<void> getNotifications(int pageKey) async {
    try {
      final repo = ref.read(notificationRepository);
      final response = await repo.getNotifications(pageKey);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = NotificationResponse.fromJson(response.data);
        final appNotifications = data.data.notifications;
        unReadNotifications = data.data.totalUnreadCount;
        final isLastPage = appNotifications.length < 20;

        if (isLastPage) {
          notificationPagingController.appendLastPage(appNotifications);
        }else {
          final nextPageKey = pageKey + 1;
          notificationPagingController.appendPage(appNotifications, nextPageKey);
        }
      } else {
        FlashCard.showError(errorMessage: "Failed to fetch all notifications.");
      }
    } catch (e) {
      log("Error fetching notifications: $e");
      FlashCard.showError(
        errorMessage: "An error occurred while fetching notifications.",
      );
    }
  }
}
