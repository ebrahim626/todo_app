import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/router/app_routers.dart';
import 'components/bottom_nav_container.dart';
import 'components/build_item.dart';

final unreadCountProvider = StateProvider<int>((ref) => 0);

class BottomNavBar extends ConsumerWidget {
  const BottomNavBar({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unreadCount = ref.watch(unreadCountProvider);

    return Scaffold(
      body: child,
      extendBody: true,
      bottomNavigationBar: BottomNavContainer(
        currentIndex: _getSelectedIndex(context, ),
        onTap: (index) => _onItemTapped(context, index),
        navItems: _buildNavItems(context,unreadCount),
      ),
    );
  }
  // items: const [
  // BottomNavigationBarItem(
  // icon: HugeIcon(icon: HugeIcons.strokeRoundedGoogleHome),
  // activeIcon: HugeIcon(icon: HugeIcons.strokeRoundedGoogleHome),
  // label: 'Home',
  // ),
  // BottomNavigationBarItem(
  // icon: HugeIcon(icon: HugeIcons.strokeRoundedTransactionHistory),
  // activeIcon: HugeIcon(icon: HugeIcons.strokeRoundedTransactionHistory),
  // label: 'History',
  // ),
  // ],
  // ),
  //

  List<BottomNavigationBarItem> _buildNavItems(BuildContext context, int unreadCount) {
      return [
        BottomNavUtils.buildItem(
          icon: Icons.home,
          activeIcon: Icons.home,
          label: 'Home',
        ),
        BottomNavUtils.notificationItem(
          label: 'History',
          notificationCount: unreadCount,
        ),
    ];
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(AppRoutes.homeRoute);
        break;
      case 1:
        context.go(AppRoutes.historyRoute);
        break;
    }
  }

  int _getSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();

    if (location.startsWith(AppRoutes.historyRoute)) return 1;

    return 0; // Default to Home
  }
}