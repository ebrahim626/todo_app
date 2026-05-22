import 'package:flutter/material.dart';
import '../../../../core/utils/extensions/context.dart';

class AppDivider extends StatelessWidget {
  const AppDivider({super.key, this.color, this.height, this.thickness});
  final Color? color;
  final double? height;
  final double? thickness;
  @override
  Widget build(BuildContext context) {
    return Divider(
      color: color ?? Color(0xffBFBFBF),
      height: height,
      thickness: thickness,
    );
  }
}
