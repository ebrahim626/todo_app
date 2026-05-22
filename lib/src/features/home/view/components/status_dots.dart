import 'package:flutter/material.dart';

import '../../../../core/utils/extensions/context.dart';

class StatusDot extends StatelessWidget {
  const StatusDot({
    super.key,
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(label, style: context.text.titleSmall),
        Padding(
          padding: const EdgeInsets.only(top: 3, left: 8),
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}