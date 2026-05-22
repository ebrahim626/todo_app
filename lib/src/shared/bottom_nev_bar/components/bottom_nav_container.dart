import 'package:flutter/material.dart';
import 'package:todo_app/src/core/utils/theme/theme.dart';

import '../../../core/utils/extensions/context.dart';

class BottomNavContainer extends StatelessWidget {
  const BottomNavContainer({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.navItems,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<BottomNavigationBarItem> navItems;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: context.isAndroid ? 12 : 18.0),
      color: primaryColor,
      child: MediaQuery.removePadding(
        context: context,
        removeBottom: true,
        child: BottomNavigationBar(
          elevation: 100,
          currentIndex: currentIndex,
          onTap: onTap,
          backgroundColor: primaryColor,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          items: navItems,
        ),
      ),
    );
  }
}
