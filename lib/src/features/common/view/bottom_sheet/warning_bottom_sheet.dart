import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app/src/core/utils/theme/theme.dart';

import '../../../../core/utils/extensions/gap.dart';
import '../app_button/app_button.dart';
import 'app_bottom_sheet.dart';

class WarningBottomSheet extends StatelessWidget {
  const WarningBottomSheet({
    super.key,
    required this.title,
    required this.subtitle,
    this.child,
    required this.primaryButtonText,
    this.secondaryButtonText,
    this.onPrimaryButtonPressed,
    this.onSecondaryButtonPressed,
  });

  final String title;
  final String subtitle;

  final Widget? child;

  final String primaryButtonText;
  final String? secondaryButtonText;

  final VoidCallback? onPrimaryButtonPressed;
  final VoidCallback? onSecondaryButtonPressed;

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String subtitle,
    Widget? child,
    required String primaryButtonText,
    String? secondaryButtonText,
    VoidCallback? onPrimaryButtonPressed,
    VoidCallback? onSecondaryButtonPressed,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      useSafeArea: true,
      builder: (BuildContext context) {
        return WarningBottomSheet(
          title: title,
          subtitle: subtitle,
          primaryButtonText: primaryButtonText,
          secondaryButtonText: secondaryButtonText,
          onPrimaryButtonPressed: onPrimaryButtonPressed,
          onSecondaryButtonPressed: onSecondaryButtonPressed,
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBottomSheetWidget(
      title: title,
      child: Column(
        children: [
          Text(subtitle),
          if (child != null) ...[8.ph, child!],
          20.ph,
          Row(
            children: [
              Expanded(
                child: AppButton(
                  borderRadius: 99,
                  onTap: onPrimaryButtonPressed,
                  buttonType: ButtonType.outlined,
                  text: primaryButtonText,
                  textColor: primaryColor,
                ),
              ),
              10.pw,
              Expanded(
                child: AppButton(
                  borderRadius: 99,
                  onTap:
                      onSecondaryButtonPressed ??
                      () {
                        context.pop();
                      },
                  text: secondaryButtonText ?? "Cancel",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
