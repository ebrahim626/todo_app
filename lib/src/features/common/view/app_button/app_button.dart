import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/utils/extensions/context.dart';
import '../../../../core/utils/theme/theme.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;

  /// button type
  final ButtonType buttonType;

  /// show/hide arrow icon
  final bool showArrow;

  final double? width;
  final double? height;
  final double? borderRadius;

  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;

  final EdgeInsetsGeometry? padding;

  final TextStyle? textStyle;

  const AppButton({
    super.key,
    required this.text,
    this.onTap,
    this.buttonType = ButtonType.filled,
    this.showArrow = false,
    this.width,
    this.height,
    this.borderRadius,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.padding,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(borderRadius ?? 99);

    final buttonChild = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          text,
          style:
          textStyle ??
              context.text.titleMedium?.copyWith(
                color: textColor ?? Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
        ),

        if (showArrow) ...[
          14.horizontalSpace,
          HugeIcon(
            icon: HugeIcons.strokeRoundedArrowRight01,
            color: textColor ?? Colors.white,
            size: 24.sp,
          ),
        ],
      ],
    );

    switch (buttonType) {
      case ButtonType.filled:
        return SizedBox(
          width: width ?? double.infinity,
          height: height,
          child: ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: backgroundColor ?? primaryColor,
              foregroundColor: textColor ?? Colors.white,
              padding:
              padding ??
                  EdgeInsets.symmetric(vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: radius,
              ),
            ),
            child: buttonChild,
          ),
        );

      case ButtonType.outlined:
        return SizedBox(
          width: width ?? double.infinity,
          height: height,
          child: OutlinedButton(
            onPressed: onTap,
            style: OutlinedButton.styleFrom(
              elevation: 0,
              foregroundColor: textColor ?? primaryColor,
              side: BorderSide(
                color: borderColor ?? primaryColor,
                width: 1.2,
              ),
              padding:
              padding ??
                  EdgeInsets.symmetric(vertical: 16.h),
              shape: RoundedRectangleBorder(
                borderRadius: radius,
              ),
            ),
            child: buttonChild,
          ),
        );

      case ButtonType.text:
        return TextButton(
          onPressed: onTap,
          style: TextButton.styleFrom(
            foregroundColor: textColor ?? primaryColor,
            padding:
            padding ??
                EdgeInsets.symmetric(vertical: 12.h),
            shape: RoundedRectangleBorder(
              borderRadius: radius,
            ),
          ),
          child: buttonChild,
        );
    }
  }
}

enum ButtonType {
  filled,
  outlined,
  text,
}