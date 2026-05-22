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
        child: Icon(icon),
      ),
      activeIcon: Padding(
        padding: const EdgeInsets.only(bottom: 3.0),
        child: Icon(activeIcon ?? icon),
      ),
      label: label,
    );
  }
}
