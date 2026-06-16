import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/utils/extensions/context.dart';
import '../../../core/utils/extensions/gap.dart';
import '../../common/view/bottom_sheet/warning_bottom_sheet.dart';
import '../../common/view/buttom/custom_rectangular_button.dart';
import '../../common/view/menu/menu_item.dart';

class SchoolMenuDrawer extends ConsumerWidget {
  const SchoolMenuDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Drawer(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: SafeArea(
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: CustomRectangularButton(
                    onTap: () {
                      context.pop();
                    },
                    icon: Icons.arrow_back_ios_new_sharp,
                  ),
                ),
                Spacer(),
              ],
            ),
            35.ph,

            // Menu Appointments
            MenuItem(
              isSelected: false,
              icon: Icons.arrow_back_ios_new_sharp,
              title: "All Enrollment",
              onTap: () {

              },
            ),

            // Menu Schedule List
            MenuItem(
              isSelected: false,
              icon: Icons.arrow_back_ios_new_sharp,
              title: "All Enrollment",
              onTap: () {

              },
            ),
            // Menu Schedule List
            MenuItem(
              isSelected: false,
              icon: Icons.arrow_back_ios_new_sharp,
              title: "All Enrollment",
              onTap: () {

              },
            ),

            // Menu Home
            MenuItem(
              isSelected: false,
              icon: Icons.arrow_back_ios_new_sharp,
              title: "All Enrollment",
              onTap: () {

              },
            ),

            // Menu Instructor List
            MenuItem(
              isSelected: false,
              icon: Icons.arrow_back_ios_new_sharp,
              title: "All Enrollment",
              onTap: () {

              },
            ),

            ListTile(
              onTap: () {
                WarningBottomSheet.show(
                  context,
                  title: "Confirm Logout",
                  subtitle:
                      "Please confirm if you would like to end your session.",
                  primaryButtonText: "Logout",
                  onPrimaryButtonPressed: () {

                  },
                );
              },
              leading: Icon(Icons.logout, size: 24),
              title: Text(
                "Logout",
                style: context.text.titleSmall?.copyWith(
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
