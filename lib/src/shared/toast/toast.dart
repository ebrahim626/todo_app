import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todo_app/src/core/utils/theme/theme.dart';

class FlashCard {
  static void showInfo({required String message, String? title}) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_LONG,
    );
  }

  static void showSuccess({required String message, String? title}) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: successColor,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_LONG,
    );
  }

  static void showError({required String errorMessage, String? title}) {
    Fluttertoast.showToast(
      msg: errorMessage,
      backgroundColor: errorColor,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_LONG,
    );
  }
}
