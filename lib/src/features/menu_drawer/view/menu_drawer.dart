import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/src/features/menu_drawer/controller/menu_drawer_controller.dart';
import '../../../core/utils/extensions/context.dart';
import '../../../core/utils/extensions/gap.dart';
import '../../common/view/bottom_sheet/warning_bottom_sheet.dart';
import '../../common/view/buttom/custom_rectangular_button.dart';
import '../../common/view/menu/menu_item.dart';

class MenuDrawer extends ConsumerWidget {
  const MenuDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(menuProvider);
    final notifier = ref.read(menuProvider.notifier);
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
              icon: Icons.calendar_today_outlined,
              title: "Task Calender",
              onTap: () {},
            ),

            // Menu Schedule List
            MenuItem(
              isSelected: false,
              icon: Icons.history,
              title: "History",
              onTap: () {},
            ),

            // Menu Schedule List
            MenuItem(
              isSelected: false,
              icon: Icons.manage_accounts_outlined,
              title: "Profile",
              onTap: () {},
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
                    notifier.logOut(context);
                  },
                  isOneButton: true,
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
