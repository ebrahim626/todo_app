import 'package:flutter/material.dart';

import '../../../../core/utils/extensions/context.dart';
import '../../../../core/utils/extensions/gap.dart';

class CardStatusWidget extends StatelessWidget {
  const CardStatusWidget({super.key, required this.statusTitle});

  final String statusTitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
        4.pw,
        Text(
          "$statusTitle",
          style: context.text.bodySmall
              ?.copyWith(color: Colors.white),
        )
      ],
    );
  }
}
