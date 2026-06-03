import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/src/core/router/app_routers.dart';
import 'package:todo_app/src/core/utils/theme/theme.dart';
import 'package:todo_app/src/features/home/controller/home_controller.dart';
import 'package:todo_app/src/features/home/view/components/card_status_widget.dart';
import 'package:todo_app/src/features/home/view/components/home_calendar.dart';
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
                    flexibleSpace: FlexibleSpaceBar(background: HomeCalendar()),
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const AppDivider(height: 1, thickness: 1),
                        12.ph,
                        Text(
                          "Monday, 25 May 2026",
                          style: context.text.titleMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        12.ph,
                        ListView.separated(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: tasks?.length ?? 0,
                          separatorBuilder: (BuildContext context, int index) {
                            return 10.ph;
                          },
                          itemBuilder: (context, index) {
                            final task = tasks?[index];
                            return Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: primaryColor,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CardStatusWidget(
                                        statusTitle: "${task?.title}",
                                      ),
                                      8.pw,
                                      CardStatusWidget(statusTitle: "${task?.taskPriority}"),
                                      8.pw,
                                      CardStatusWidget(statusTitle: "${task?.taskStatus}"),
                                      Spacer(),
                                      GestureDetector(
                                        onTapDown: (TapDownDetails details) {
                                          final RenderBox overlay =
                                              Overlay.of(
                                                    context,
                                                  ).context.findRenderObject()
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
                                            position: RelativeRect.fromRect(
                                              details.globalPosition &
                                                  const Size(40, 40),
                                              Offset.zero & overlay.size,
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
                                              PopupMenuItem<String>(
                                                value: 'reschedule',
                                                height: 40,
                                                child: ListTile(
                                                  dense: true,
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                      ),
                                                  title: Text("Reschedule"),
                                                ),
                                              ),
                                              PopupMenuItem<String>(
                                                value: 'change_status',
                                                height: 40,
                                                child: ListTile(
                                                  dense: true,
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                      ),
                                                  title: Text("Change Status"),
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
                                            } else if (value == 'reschedule') {
                                              // handle reschedule
                                            } else if (value ==
                                                'change_status') {
                                              // handle change status
                                            } else if (value == 'delete') {
                                              // handle delete
                                            }
                                          });
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(3),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              99,
                                            ),
                                            color: Colors.white,
                                          ),
                                          child: Icon(
                                            Icons.more_vert,
                                            size: 18,
                                            color: primaryColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "${task?.taskType}",
                                    style: context.text.titleSmall?.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                  4.ph,
                                  Text(
                                    "${task?.description}",
                                    style: context.text.bodySmall?.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Spacer(),
                                      Text(
                                        "Due: ${task?.dueDate}",
                                        style: context.text.bodySmall?.copyWith(
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
          ],
        ),
      ),
    );
  }
}
