import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/utils/extensions/context.dart';
import '../../../../core/utils/extensions/gap.dart';
import '../../../../core/utils/theme/theme.dart';
import '../divider/app_divider.dart';

class AppBottomSheetWidget extends StatelessWidget {
  final String? title;
  final TextStyle? titleStyle;
  final Widget? titleWidget;
  final Widget child;
  final bool showDivider;

  const AppBottomSheetWidget({
    super.key,
    required this.child,
    this.title,
    this.titleWidget,
    this.showDivider = true,
    this.titleStyle,
  });

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height * 0.85;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: maxHeight, // 🔒 CRITICAL
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                title != null
                    ? Text(
                        title!,
                        style:
                            titleStyle ??
                            context.text.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                      )
                    : titleWidget ?? const SizedBox.shrink(),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  visualDensity: VisualDensity.compact,
                  onPressed: () => Navigator.pop(context),
                  icon: HugeIcon(
                    icon: HugeIcons.strokeRoundedMultiplicationSign,
                    color: context.theme.dividerColor,
                  ),
                ),
              ],
            ),

            if (showDivider) const AppDivider(color: stockColor, thickness: 1),

            8.ph,

            /// 🔥 SCROLLABLE BODY
            Flexible(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
