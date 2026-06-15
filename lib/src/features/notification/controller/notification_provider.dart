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
  bool isLoading = false;
  final PagingController<int, AppNotification> notificationPagingController =
      PagingController(firstPageKey: 1);

  @override
  FutureOr<dynamic> build() async {
    notificationPagingController.addPageRequestListener((pageKey) async {
      await getNotifications(pageKey: pageKey, pageSize: 15);
    });
  }

  bool get hasData {
    final items = notificationPagingController.itemList;
    return items != null && items.isNotEmpty;
  }

  Future<void> getNotifications({required int pageKey, required int pageSize}) async {
    try {
      final repo = ref.read(notificationRepository);
      final response = await repo.getNotifications(pageKey: pageKey,pageSize: pageSize);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = NotificationResponse.fromJson(response.data);
        final appNotifications = data.data.notifications;
        final isLastPage = appNotifications.length < pageSize;

        if (isLastPage) {
          notificationPagingController.appendLastPage(appNotifications);
        } else {
          final nextPageKey = pageKey + 1;
          notificationPagingController.appendPage(
            appNotifications,
            nextPageKey,
          );
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

  Future<void> markAsRead() async {
    try {
      isLoading = true;
      final repo = ref.read(notificationRepository);
      final response = await repo.markAsRead();

      if (response.statusCode == 200 || response.statusCode == 201) {
        log("Notification marked as read successfully");
        FlashCard.showSuccess(message: response.data["message"]);
      } else {
        FlashCard.showError(errorMessage: "Failed to marked notifications as read");
      }
    } catch (e) {
      log("Error mark notifications: $e");
      FlashCard.showError(
        errorMessage: "An error occurred while marking notifications.",
      );
    }finally {
      isLoading = false;
    }
  }

}
