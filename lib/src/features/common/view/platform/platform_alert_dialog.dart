import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class PlatformAlertDialog {
  // Static method to show dialog based on platform
  static Future<void> show({
    required BuildContext context,
    required String title,
    required String message,
    String okButtonText = 'OK',
    VoidCallback? onOkPressed,
  }) async {
    // Check if iOS
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      return _showCupertinoDialog(
        context: context,
        title: title,
        message: message,
        okButtonText: okButtonText,
        onOkPressed: onOkPressed,
      );
    }

    // Default to Material/Android
    return _showMaterialDialog(
      context: context,
      title: title,
      message: message,
      okButtonText: okButtonText,
      onOkPressed: onOkPressed,
    );
  }

  // Material Design Dialog (Android)
  static Future<void> _showMaterialDialog({
    required BuildContext context,
    required String title,
    required String message,
    required String okButtonText,
    VoidCallback? onOkPressed,
  }) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onOkPressed?.call();
              },
              child: Text(okButtonText),
            ),
          ],
        );
      },
    );
  }

  // iOS Style Dialog
  static Future<void> _showCupertinoDialog({
    required BuildContext context,
    required String title,
    required String message,
    required String okButtonText,
    VoidCallback? onOkPressed,
  }) async {
    return showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(context).pop();
                onOkPressed?.call();
              },
              child: Text(okButtonText),
            ),
          ],
        );
      },
    );
  }
}
