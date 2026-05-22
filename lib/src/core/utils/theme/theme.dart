import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const lightUiConfig = SystemUiOverlayStyle(
  statusBarColor: Colors.transparent,
  statusBarBrightness: Brightness.light,
  statusBarIconBrightness: Brightness.dark,
  systemNavigationBarColor: Colors.white,
  systemNavigationBarIconBrightness: Brightness.dark,
);

/// MAIN COLORS
const primaryColor = Color(0xff1FB4C4);

/// STATUS COLORS
const closedColor = Color(0xffED6B6B);
const pendingColor = Color(0xffB4B4B4);
const upcomingColor = Color(0xffF5B041);

/// Flashcard Color
const successColor = Color(0xff34C759);
const errorColor = Color(0xffED6B6B);

/// TEXT COLORS
const bigTextColor = Color(0xff585858);
const textColor = Color(0xff000000);

/// BODY TEXT COLOR (same as previous)
const bodyTextColor = Color(0xff6F6C6A);
const greyContainer = Color(0xffD9D9D9);

/// BACKGROUND
const backgroundColor = Color(0xffEEFAFF);
const scaffoldBackgroundColor = backgroundColor;


final textTheme = TextTheme(
  titleLarge: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: bigTextColor,
  ),

  titleMedium: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: textColor,
  ),

  titleSmall: TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: textColor,
  ),

  bodyLarge: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: bodyTextColor,
  ),

  bodyMedium: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: bodyTextColor,
  ),

  bodySmall: TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: bodyTextColor,
  ),
).apply(fontFamily: "Urbanist");

final lightTheme = ThemeData(
  useMaterial3: true,
  primaryColor: primaryColor,
  scaffoldBackgroundColor: scaffoldBackgroundColor,
  brightness: Brightness.light,

  textTheme: textTheme,

  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    surfaceTintColor: Colors.white,
    elevation: 0,
    iconTheme: IconThemeData(color: textColor),
    titleTextStyle: TextStyle(
      color: textColor,
      fontSize: 18,
      fontWeight: FontWeight.w700,
    ),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      minimumSize: const Size(double.infinity, 48),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    contentPadding: const EdgeInsets.all(16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: pendingColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: primaryColor),
    ),
  ),

  colorScheme: ColorScheme.light(
    primary: primaryColor,
    secondary: upcomingColor,
    error: closedColor,
  ),
);