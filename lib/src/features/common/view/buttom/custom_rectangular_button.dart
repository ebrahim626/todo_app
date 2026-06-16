import 'package:flutter/material.dart';

class CustomRectangularButton extends StatelessWidget {
  const CustomRectangularButton({
    super.key,
    this.onTap,
    required this.icon,
    this.iconColor,
  });

  final VoidCallback? onTap;
  final IconData icon;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade400, width: 1),
        ),
        child: Icon(icon, size: 16, color: iconColor),
      ),
    );
  }
}
