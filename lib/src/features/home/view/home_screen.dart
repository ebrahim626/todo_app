import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/src/core/router/app_routers.dart';
import 'package:todo_app/src/core/service/date_formatter.dart';
import 'package:todo_app/src/core/service/time_formatter.dart';
import 'package:todo_app/src/core/utils/theme/theme.dart';
import 'package:todo_app/src/features/common/view/bottom_sheet/warning_bottom_sheet.dart';
import 'package:todo_app/src/features/home/view/components/task_priority.dart';
import 'package:todo_app/src/features/home/controller/home_controller.dart';
import 'package:todo_app/src/features/home/view/components/card_status_widget.dart';
import 'package:todo_app/src/features/home/view/components/home_calendar.dart';
import 'package:todo_app/src/features/home/view/components/task_status.dart';
import '../../../core/utils/extensions/context.dart';
import '../../../core/utils/extensions/gap.dart';
import '../../common/view/divider/app_divider.dart';
import 'components/status_dots.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static const String name = 'home';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(homeControllerProvider);
    final notifier = ref.watch(homeControllerProvider.notifier);
    final tasks = ref.watch(homeControllerProvider.notifier).todoTasks;

    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(
          bottom: 75,
        ), // adjust to sit above your nav bar
        child: FloatingActionButton(
          onPressed: () {
            context.push(AppRoutes.addTaskRoute);
          },

          shape: const CircleBorder(
            side: BorderSide(color: backgroundColor, width: 2),
          ),
          child: const Icon(Icons.add, size: 40),
        ),
      ),
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 45),
        child: Column(
          children: [
            Row(
              children: [
                StatusDot(label: 'Done', color: primaryColor),
                12.pw,
                StatusDot(label: 'Closed', color: closedColor),
                12.pw,
                StatusDot(label: 'Pending', color: pendingColor),
                12.pw,
                StatusDot(label: 'Upcoming', color: upcomingColor),
                Spacer(),
                IconButton(
                  onPressed: () {
                    // Implement menu action here
                    notifier.logOut(context);
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
              ],
            ),
            18.ph,
            const AppDivider(height: 1, thickness: 1),
            5.ph,
            Expanded(
              child: RefreshIndicator(
                onRefresh: () {
                  return notifier.refresh();
                },
                backgroundColor: primaryColor,
                color: backgroundColor,
                child: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      floating: true,
                      pinned: false,
                      backgroundColor: backgroundColor,
                      expandedHeight: 358,
                      collapsedHeight: 0,
                      toolbarHeight: 0,
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      flexibleSpace: FlexibleSpaceBar(
                        background: HomeCalendar(
                          notifier: notifier,
                          selectedDay: notifier.selectedDate,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const AppDivider(height: 1, thickness: 1),
                          12.ph,
                          Text(
                            // "Monday, 25 May 2026"
                            "${DateFormatter.formatDateWithDay(notifier.selectedDate)}",
                            style: context.text.titleMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          12.ph,
                          tasks == null || tasks.isEmpty
                              ? Container(
                                  height: 180,
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: primaryColor,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "No tasks for this day.",
                                        style: context.text.bodyLarge?.copyWith(
                                          color: Colors.white,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      6.ph,
                                      Text(
                                        "Dates with tasks will display colored dots below them, indicating the status of the tasks for that day.",
                                        style: context.text.labelSmall
                                            ?.copyWith(color: Colors.white),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                )
                              : ListView.separated(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: tasks.length,
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                        return 10.ph;
                                      },
                                  itemBuilder: (context, index) {
                                    final task = tasks[index];
                                    return Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: notifier.getStatusColor(
                                          task.taskStatus,
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              CardStatusWidget(
                                                statusTitle: "${task.taskType}",
                                              ),
                                              8.pw,
                                              CardStatusWidget(
                                                statusTitle:
                                                    "${TaskPriority.getLabel(task.taskPriority)}",
                                              ),
                                              8.pw,
                                              CardStatusWidget(
                                                statusTitle:
                                                    "${TaskStatus.getLabel(task.taskStatus)}",
                                              ),
                                              Spacer(),
                                              GestureDetector(
                                                onTapDown: (TapDownDetails details) {
                                                  final RenderBox overlay =
                                                      Overlay.of(context)
                                                              .context
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
                                                              const Size(
                                                                40,
                                                                40,
                                                              ),
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
                                                      if (task.taskStatus != 1)
                                                        PopupMenuItem<String>(
                                                          value: 'mark_as_done',
                                                          height: 40,
                                                          child: ListTile(
                                                            dense: true,
                                                            contentPadding:
                                                                EdgeInsets.symmetric(
                                                                  horizontal:
                                                                      12,
                                                                ),
                                                            title: Text(
                                                              "Mark As Done",
                                                            ),
                                                          ),
                                                        ),
                                                      if (task.taskStatus != 2)
                                                        PopupMenuItem<String>(
                                                          value:
                                                              'mark_as_closed',
                                                          height: 40,
                                                          child: ListTile(
                                                            dense: true,
                                                            contentPadding:
                                                                EdgeInsets.symmetric(
                                                                  horizontal:
                                                                      12,
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
                                                        extra: task,
                                                      );
                                                    } else if (value ==
                                                        'mark_as_done') {
                                                      // handle change status
                                                      notifier.updateStatus(
                                                        context,
                                                        task: task,
                                                        taskStatus: 1,
                                                      );
                                                    } else if (value ==
                                                        'mark_as_closed') {
                                                      // handle change status
                                                      notifier.updateStatus(
                                                        context,
                                                        task: task,
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
                                                        onPrimaryButtonPressed: () {
                                                          notifier.deleteTask(context, taskId: task.id);
                                                        }
                                                      );
                                                    }
                                                  });
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(3),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          99,
                                                        ),
                                                    color: Colors.white,
                                                  ),
                                                  child: Icon(
                                                    Icons.more_vert,
                                                    size: 18,
                                                    color: notifier
                                                        .getStatusColor(
                                                          task.taskStatus,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            "${task.title}",
                                            style: context.text.titleSmall
                                                ?.copyWith(color: Colors.white),
                                          ),
                                          if (task.description != "") ...[
                                            4.ph,
                                            Text(
                                              "${task.description}",
                                              style: context.text.bodySmall
                                                  ?.copyWith(
                                                    color: Colors.white,
                                                  ),
                                              maxLines: 2,
                                            ),
                                          ],
                                          4.ph,
                                          Row(
                                            children: [
                                              Spacer(),
                                              Text(
                                                "Due Time: ${DateTimeFormatter.time(task.dueDate)}",
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
                                    );
                                  },
                                ),
                          145.ph,
                        ],
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
