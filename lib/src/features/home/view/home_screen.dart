import 'package:flutter/material.dart';
import 'package:todo_app/src/core/utils/theme/theme.dart';
import 'package:todo_app/src/features/home/view/components/card_status_widget.dart';
import 'package:todo_app/src/features/home/view/components/home_calendar.dart';
import '../../../core/utils/extensions/context.dart';
import '../../../core/utils/extensions/gap.dart';
import '../../common/view/divider/app_divider.dart';
import 'components/status_dots.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const String name = 'home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    expandedHeight: 355,
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
                          itemCount: 15,
                          separatorBuilder: (BuildContext context, int index) {
                            return 10.ph;
                          },
                          itemBuilder: (context, index) {
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
                                        statusTitle: "Maintenance",
                                      ),
                                      8.pw,
                                      CardStatusWidget(statusTitle: "Must Do"),
                                      8.pw,
                                      CardStatusWidget(statusTitle: "Done"),
                                      Spacer(),
                                      InkWell(
                                        onTap: () {
                                          // Implement more options action here
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
                                    "Need To Fix Main Door Lock",
                                    style: context.text.titleSmall?.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                  4.ph,
                                  Text(
                                    "Main door lock got broken need to contact a good key mechanic as soon as possible  Mostafijur knows a good...",
                                    style: context.text.bodySmall?.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Spacer(),
                                      Text(
                                        "Today, 10:00 AM",
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
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                        // Row(
                        //   children: [
                        //     Expanded(
                        //       child: Container(
                        //         child: Column(
                        //           children: [
                        //             //CachedNetworkImage(imageUrl: ),
                        //
                        //             ClipRRect(
                        //               borderRadius: BorderRadius.circular(12),
                        //               child: CachedNetworkImage(
                        //                 imageUrl: "https://static.vecteezy.com/system/resources/thumbnails/020/441/564/small/street-racing-illustration-icon-red-sport-car-template-illustration-can-use-logo-t-shirt-apparel-sticker-group-community-poster-flyer-banner-modify-auto-show-vector.jpg",
                        //                 height: 120,
                        //                 width: double.infinity,
                        //                 fit: BoxFit.cover,
                        //                 placeholder: (context, url) => Container(
                        //                   height: 120,
                        //                   width: double.infinity,
                        //                   color: Colors.grey[300],
                        //                   child: Center(
                        //                     child: CircularProgressIndicator.adaptive(),
                        //                   ),
                        //                 ),
                        //                 errorWidget: (context, url, error) => Container(
                        //                   height: 120,
                        //                   width: double.infinity,
                        //                   color: Colors.grey[300],
                        //                   child: Icon(Icons.error),
                        //                 ),
                        //                 errorListener: (value){},
                        //               ),
                        //             ),
                        //             Text("Private car dallas"),
                        //             AppButton(
                        //               color: primaryColor,
                        //               onPressed: () {},
                        //               child: Text("Book Now",
                        //                 style: context.text.titleSmall?.copyWith(
                        //                   color: Colors.white,
                        //                   fontWeight: FontWeight.w600
                        //                 ),
                        //               ),
                        //             )
                        //           ],
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // )
                        // ListView.builder(
                        //   shrinkWrap: true,
                        //   physics: const NeverScrollableScrollPhysics(),
                        //   itemCount: 100, // You should add itemCount
                        //   itemBuilder: (context, index) {
                        //     return Text("Hello $index");
                        //   },
                        // ),
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
