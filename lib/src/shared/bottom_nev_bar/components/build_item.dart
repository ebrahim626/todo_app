import 'package:flutter/material.dart';

class BottomNavUtils {
  static BottomNavigationBarItem buildItem({
    IconData? icon,
    IconData? activeIcon,
    required String label,
  }) {
    return BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.only(bottom: 3),
        child: Icon(icon, size: 28),
      ),
      activeIcon: Padding(
        padding: const EdgeInsets.only(bottom: 3),
        child: Icon(activeIcon ?? icon, size: 36),
      ),
      label: label,
    );
  }

  static BottomNavigationBarItem notificationItem({
    required String label,
    required int notificationCount,
  }) {
    Widget buildNotificationIcon(IconData icon, double size) {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 3),
            child: Icon(icon, size: size),
          ),

          if (notificationCount > 0)
            Positioned(
              right: -4,
              top: -2,
              child: Container(
                padding: const EdgeInsets.all(4),
                constraints: const BoxConstraints(
                  minWidth: 18,
                  minHeight: 18,
                ),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  notificationCount > 99
                      ? '99+'
                      : notificationCount.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      );
    }

    return BottomNavigationBarItem(
      icon: buildNotificationIcon(
        Icons.history,
        28,
      ),
      activeIcon: buildNotificationIcon(
        Icons.history,
        36,
      ),
      label: label,
    );
  }
}