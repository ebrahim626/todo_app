import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:todo_app/src/features/history/repository/history_repository.dart';
import '../../../core/utils/theme/theme.dart';
import '../../../shared/toast/toast.dart';
import '../../home/get_task_model/response/get_task_model.dart';

typedef HistoryNotifier = AsyncNotifierProvider<HistoryProvider, void>;
final historyProvider = HistoryNotifier(HistoryProvider.new);

class HistoryProvider extends AsyncNotifier {
  final PagingController<int, TodoModel> taskPagingController =
      PagingController(firstPageKey: 1);

  @override
  FutureOr<dynamic> build() async {
    ref.onDispose(() {
      taskPagingController.dispose();
    });

    taskPagingController.addPageRequestListener((pageKey) async {
      await getTasksHistory(page: pageKey);
    });
  }

  Color getStatusColor(int status) {
    switch (status) {
      case 1:
        return primaryColor;
      case 2:
        return closedColor;
      case 3:
        return pendingColor;
      case 4:
        return upcomingColor;
      default:
        return Colors.grey;
    }
  }

  void refresh() {
    taskPagingController.refresh(); // triggers pageRequestListener → API call
  }

  FutureOr<void> getTasksHistory({required int page, int pageSize = 10}) async {
    try {
      final repoData = ref.read(historyRepository);

      final allResponse = await repoData.getHistoryTasks(
        page: page,
        pageSize: pageSize,
      );

      if (allResponse.statusCode == 200) {
        final data = TodoListResponse.fromJson(allResponse.data);
        final newItems = data.data.data;
        final isLastPage = newItems.length < pageSize;

        if (isLastPage) {
          taskPagingController.appendLastPage(newItems);
        } else {
          final nextPageKey = page + 1;
          taskPagingController.appendPage(newItems, nextPageKey);
        }
      } else {
        FlashCard.showError(errorMessage: "Failed to fetch history tasks.");
      }
    } catch (e) {
      log("Error fetching tasks: $e");
      FlashCard.showError(
        errorMessage: "An error occurred while fetching tasks.",
      );
    }
  }
}
