import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:todo_app/src/core/service/date_formatter.dart';
import 'package:todo_app/src/core/utils/extensions/context.dart';
import 'package:todo_app/src/features/common/providers/unreadCountProvider.dart';
import 'package:todo_app/src/features/common/view/custom_widgets/no_item_found_container.dart';
import 'package:todo_app/src/features/common/view/divider/app_divider.dart';
import 'package:todo_app/src/features/history/controller/history_provider.dart';
import 'package:todo_app/src/features/home/get_task_model/response/get_task_model.dart';
import '../../../core/router/app_routers.dart';
import '../../../core/service/time_formatter.dart';
import '../../../core/utils/extensions/gap.dart';
import '../../../core/utils/theme/theme.dart';
import '../../common/providers/drawer_key_provider.dart';
import '../../common/view/bottom_sheet/warning_bottom_sheet.dart';
import '../../home/view/components/card_status_widget.dart';
import '../../home/view/components/task_priority.dart';
import '../../home/view/components/task_status.dart';
import '../../menu_drawer/menu_drawer/view/menu_drawer.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  static const String name = 'history-screen';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(historyProvider);
    final notifier = ref.read(historyProvider.notifier);
    final unreadCount = ref.watch(unreadCountProvider); // 👈 reactive, persists across tabs

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 45),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 24),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      ref.read(shellScaffoldKeyProvider).currentState?.openDrawer();
                    },
                    icon: Icon(Icons.menu, size: 32),
                    padding: EdgeInsets.zero,
                    constraints:
                        const BoxConstraints(), // 👈 Remove minimum size constraint
                    style: const ButtonStyle(
                      tapTargetSize: MaterialTapTargetSize
                          .shrinkWrap, // 👈 Remove tap target padding
                    ),
                  ),
                  16.pw,
                  Text("Task History", style: context.text.bodyLarge),
                  Spacer(),
                  InkWell(
                    onTap: () {
                      context.push(AppRoutes.notificationRoute);
                    },
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Icon(Icons.notifications_none_outlined, size: 32),
                        if(unreadCount != 0)
                        Positioned(
                          top: -4,
                          right: -4,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Color(0xFFED6B6B),
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 18,
                              minHeight: 18,
                            ),
                            child: Text(
                              unreadCount > 99
                                  ? '99+'
                                  : unreadCount.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                height: 1,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            20.ph,
            AppDivider(),
            12.ph,
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Row(
                      children: [
                        PopupMenuButton<String>(
                          onOpened: () => notifier.setStatusMenuState(true),
                          onCanceled: () => notifier.setStatusMenuState(false),
                          offset: const Offset(0, 36),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          onSelected: (value) => notifier.filterByStatus(value),
                          itemBuilder: (context) => notifier.taskStatusList
                              .map(
                                (s) => PopupMenuItem(value: s, child: Text(s)),
                              )
                              .toList(),
                          color: backgroundColor,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(99),
                              border: notifier.dropDownLabel != null
                                  ? null
                                  : Border.all(color: Colors.black54),
                              color: notifier.dropDownLabel != null
                                  ? primaryColor
                                  : backgroundColor,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  notifier.dropDownLabel ?? "Status",
                                  style: context.text.bodyMedium?.copyWith(
                                    color:
                                        notifier.dropDownLabel != null
                                        ? Colors.white
                                        : textColor,
                                  ),
                                ),
                                Icon(
                                  notifier.isStatusMenuOpen
                                      ? Icons.keyboard_arrow_up_outlined
                                      : Icons.keyboard_arrow_down_outlined,
                                  color: notifier.dropDownLabel != null
                                      ? Colors.white
                                      : textColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                        10.pw,
                        PopupMenuButton<String>(
                          onOpened: () => notifier.setPriorityMenuState(true),
                          onCanceled: () =>
                              notifier.setPriorityMenuState(false),
                          offset: const Offset(0, 36),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          onSelected: (value) =>
                              notifier.filterByPriority(value),
                          itemBuilder: (context) => notifier.priorityList
                              .map(
                                (s) => PopupMenuItem(value: s, child: Text(s)),
                              )
                              .toList(),
                          color: backgroundColor,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(99),
                              border: notifier.dropDownPriorityLabel != null
                                  ? null
                                  : Border.all(color: Colors.black54),
                              color: notifier.dropDownPriorityLabel != null
                                  ? primaryColor
                                  : backgroundColor,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  notifier.dropDownPriorityLabel ?? "Priority",
                                  style: context.text.bodyMedium?.copyWith(
                                    color:
                                        notifier.dropDownPriorityLabel != null
                                        ? Colors.white
                                        : textColor,
                                  ),
                                ),
                                Icon(
                                  notifier.isPriorityMenuOpen
                                      ? Icons.keyboard_arrow_up_outlined
                                      : Icons.keyboard_arrow_down_outlined,
                                  color: notifier.dropDownPriorityLabel != null
                                      ? Colors.white
                                      : textColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Spacer(),
                        Icon(Icons.calendar_today_outlined, size: 32),
                      ],
                    ),
                    12.ph,
                    AppDivider(),
                    Expanded(
                      child: RefreshIndicator(
                        color: Colors.white,
                        backgroundColor: primaryColor,
                        onRefresh: notifier.refresh,
                        child: CustomScrollView(
                          slivers: [
                            PagedSliverList(
                              pagingController: notifier.taskPagingController,
                              builderDelegate: PagedChildBuilderDelegate<TodoModel>(
                                noItemsFoundIndicatorBuilder: (context) => Align(
                                  alignment: Alignment.topCenter,
                                  child: NoItemFoundContainer(
                                    title: "No History Available",
                                    subTitle:
                                        "Task history will appear here once tasks are completed or become past due. Upcoming tasks are excluded.",
                                  ),
                                ),
                                itemBuilder: (context, item, index) => Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: notifier.getStatusColor(
                                        item.taskStatus,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            CardStatusWidget(
                                              statusTitle: "${item.taskType}",
                                            ),
                                            8.pw,
                                            CardStatusWidget(
                                              statusTitle:
                                                  "${TaskPriority.getLabel(item.taskPriority)}",
                                            ),
                                            8.pw,
                                            CardStatusWidget(
                                              statusTitle:
                                                  "${TaskStatus.getLabel(item.taskStatus)}",
                                            ),
                                            Spacer(),
                                            GestureDetector(
                                              onTapDown: (TapDownDetails details) {
                                                final RenderBox overlay =
                                                    Overlay.of(context).context
                                                            .findRenderObject()
                                                        as RenderBox;
                                                showMenu(
                                                  context: context,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadiusGeometry.circular(
                                                          12,
                                                        ),
                                                  ),
                                                  color: const Color(
                                                    0xffEEFAFF,
                                                  ), // menu background color
                                                  position:
                                                      RelativeRect.fromRect(
                                                        details.globalPosition &
                                                            const Size(40, 40),
                                                        Offset.zero &
                                                            overlay.size,
                                                      ),
                                                  items: [
                                                    PopupMenuItem<String>(
                                                      value: 'edit',
                                                      height: 40,
                                                      child: ListTile(
                                                        dense: true,
                                                        contentPadding:
                                                            EdgeInsets.symmetric(
                                                              horizontal: 12,
                                                            ),
                                                        title: Text("Edit"),
                                                      ),
                                                    ),
                                                    if (item.taskStatus != 1)
                                                      PopupMenuItem<String>(
                                                        value: 'mark_as_done',
                                                        height: 40,
                                                        child: ListTile(
                                                          dense: true,
                                                          contentPadding:
                                                              EdgeInsets.symmetric(
                                                                horizontal: 12,
                                                              ),
                                                          title: Text(
                                                            "Mark As Done",
                                                          ),
                                                        ),
                                                      ),
                                                    if (item.taskStatus != 2)
                                                      PopupMenuItem<String>(
                                                        value: 'mark_as_closed',
                                                        height: 40,
                                                        child: ListTile(
                                                          dense: true,
                                                          contentPadding:
                                                              EdgeInsets.symmetric(
                                                                horizontal: 12,
                                                              ),
                                                          title: Text(
                                                            "Mark As Closed",
                                                          ),
                                                        ),
                                                      ),
                                                    PopupMenuItem<String>(
                                                      value: 'delete',
                                                      height: 40,
                                                      child: ListTile(
                                                        dense: true,
                                                        contentPadding:
                                                            EdgeInsets.symmetric(
                                                              horizontal: 12,
                                                            ),
                                                        title: Text(
                                                          "Delete",
                                                          style: TextStyle(
                                                            color: Colors.red,
                                                          ), // 👈 red delete
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ).then((value) {
                                                  if (value == 'edit') {
                                                    // handle edit
                                                    context.push(
                                                      AppRoutes.addTaskRoute,
                                                      extra: item,
                                                    );
                                                  } else if (value ==
                                                      'mark_as_done') {
                                                    // handle change status
                                                    notifier.updateStatus(
                                                      context,
                                                      task: item,
                                                      taskStatus: 1,
                                                    );
                                                  } else if (value ==
                                                      'mark_as_closed') {
                                                    // handle change status
                                                    notifier.updateStatus(
                                                      context,
                                                      task: item,
                                                      taskStatus: 2,
                                                    );
                                                  } else if (value ==
                                                      'delete') {
                                                    // handle delete
                                                    WarningBottomSheet.show(
                                                      context,
                                                      title:
                                                          "Delete this task?",
                                                      subtitle:
                                                          "This action cannot be undone. The task will be permanently removed.",
                                                      primaryButtonText:
                                                          "Delete",
                                                      onPrimaryButtonPressed:
                                                          () {
                                                            notifier.deleteTask(
                                                              context,
                                                              taskId: item.id,
                                                            );
                                                          },
                                                    );
                                                  }
                                                });
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(3),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(99),
                                                  color: Colors.white,
                                                ),
                                                child: Icon(
                                                  Icons.more_vert,
                                                  size: 18,
                                                  color: notifier
                                                      .getStatusColor(
                                                        item.taskStatus,
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          "${item.title}",
                                          style: context.text.titleSmall
                                              ?.copyWith(color: Colors.white),
                                        ),
                                        if (item.description
                                            .trim()
                                            .isNotEmpty) ...[
                                          4.ph,
                                          Text(
                                            item.description,
                                            style: context.text.bodySmall
                                                ?.copyWith(color: Colors.white),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                        4.ph,
                                        Row(
                                          children: [
                                            Text(
                                              "${DateFormatter.formatDate(item.dueDate ?? DateTime.now())}",
                                              style: context.text.bodySmall
                                                  ?.copyWith(
                                                    color: Colors.white,
                                                  ),
                                            ),
                                            Spacer(),
                                            Text(
                                              "Time: ${DateTimeFormatter.time(item.dueDate)}",
                                              style: context.text.bodySmall
                                                  ?.copyWith(
                                                    color: Colors.white,
                                                  ),
                                            ),
                                            // Spacer(),
                                            // Container(
                                            //   padding: EdgeInsets.symmetric(
                                            //     horizontal: 8,
                                            //     vertical: 4,
                                            //   ),
                                            //   decoration: BoxDecoration(
                                            //     borderRadius:
                                            //         BorderRadius.circular(8),
                                            //     color: Colors.white,
                                            //   ),
                                            //   child: Text(
                                            //     "View Details",
                                            //     style:
                                            //         context.text.bodySmall?.copyWith(
                                            //       color: primaryColor,
                                            //       fontWeight: FontWeight.w500,
                                            //     ),
                                            //   ),
                                            // )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                firstPageErrorIndicatorBuilder: (context) =>
                                    Container(height: 55, child: Text("hello")),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
