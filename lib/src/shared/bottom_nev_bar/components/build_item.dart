import 'package:flutter/material.dart';

class BottomNavUtils {
  static BottomNavigationBarItem buildItem({
    IconData? icon,
    IconData? activeIcon,
    required String label,
  }) {
    return BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.only(bottom: 3.0),
        child: Icon(icon, size: 30,),
      ),
      activeIcon: Padding(
        padding: const EdgeInsets.only(bottom: 3.0),
        child: Icon(activeIcon ?? icon,size: 38,),
      ),
      label: label,
    );
  }
}
