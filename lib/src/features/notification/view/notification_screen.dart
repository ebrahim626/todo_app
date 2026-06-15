import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:todo_app/src/core/service/time_formatter.dart';
import 'package:todo_app/src/core/utils/extensions/context.dart';
import 'package:todo_app/src/features/common/view/custom_widgets/no_item_found_container.dart';
import 'package:todo_app/src/features/notification/controller/notification_provider.dart';
import 'package:todo_app/src/features/notification/notification_model/response/Notification_response.dart';
import 'package:todo_app/src/shared/bottom_nev_bar/bottom_nev_bar.dart';
import '../../../core/utils/extensions/gap.dart';
import '../../../core/utils/theme/theme.dart';

class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});

  static const String name = 'notification-screen';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(notificationProvider);
    final notifier = ref.read(notificationProvider.notifier);
    final unReadNotification = ref.watch(unreadCountProvider);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (unReadNotification > 0) {
          notifier.markAsRead();
        }
        Navigator.of(context).pop(); // 👈 bypasses PopScope, no recursion
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: backgroundColor,
          elevation: 0,
          leading: IconButton(
            padding: EdgeInsets.only(left: 24),
            icon: Icon(Icons.arrow_back_ios_new_sharp, size: 32),
            onPressed: () {
              Navigator.of(context).maybePop();
            },
          ),

          centerTitle: true,
          title: Text(
            "Notifications",
            style: context.text.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),

          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.0),
            child: Container(height: 1.0, color: dividerColor),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    PagedSliverList(
                      pagingController: notifier.notificationPagingController,
                      builderDelegate: PagedChildBuilderDelegate<AppNotification>(
                        noItemsFoundIndicatorBuilder: (context) => Align(
                          alignment: Alignment.topCenter,
                          child: NoItemFoundContainer(
                            title: "No notifications at this moment.",
                            subTitle:
                                "New notifications will appear here. Unread items will be highlighted with a count on the notification icon.",
                          ),
                        ),
                        itemBuilder: (context, item, index) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: item.isRead ? pendingColor : primaryColor,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: backgroundColor,
                                  ),
                                  child: Text(
                                    "${item.title}",
                                    style: context.text.titleSmall?.copyWith(
                                      color: primaryColor,
                                    ),
                                  ),
                                ),
                                6.ph,
                                Text(
                                  "${item.body}",
                                  style: context.text.titleSmall?.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                                6.ph,
                                Row(
                                  children: [
                                    Spacer(),
                                    Text(
                                      "${DateTimeFormatter.timeAgo(item.sentAt)}",
                                      style: context.text.titleSmall?.copyWith(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(height: 85),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
