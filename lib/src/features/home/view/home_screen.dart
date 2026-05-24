import 'package:flutter/material.dart';
import 'package:todo_app/src/core/utils/theme/theme.dart';
import 'package:todo_app/src/features/home/view/components/home_calendar.dart';
import '../../../core/utils/extensions/gap.dart';
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
                  onPressed: () {},
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
            HomeCalendar()
          ],
        ),
      ),
    );
  }
}
