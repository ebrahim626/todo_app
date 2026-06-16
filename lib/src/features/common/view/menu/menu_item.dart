import 'package:flutter/material.dart';
import '../../../../core/utils/extensions/context.dart';
import '../../../../core/utils/theme/theme.dart';

class MenuItem extends StatelessWidget {
  const MenuItem({
    super.key,
    required this.isSelected,
    this.onTap,
    required this.icon,
    required this.title,
  });

  final bool isSelected;
  final VoidCallback? onTap;
  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: isSelected ? Color(0xffFFF2F6) : Colors.transparent,
      shape: const RoundedRectangleBorder(),
      onTap: onTap,
      leading: Icon(
        icon,
        size: 24,
        color: isSelected ? primaryColor : bodyTextColor,
      ),
      title: Text(
        title,
        style: context.text.titleSmall?.copyWith(
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
          color: isSelected ? primaryColor : textColor,
        ),
      ),
    );
  }
}
