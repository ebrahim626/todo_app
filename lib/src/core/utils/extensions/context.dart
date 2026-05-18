import 'package:flutter/material.dart';

enum ScreenType { mobile, desktop }

extension BuildContextExtension on BuildContext {
  // Reference screen dimensions from Figma
  static const double _referenceHeight = 852.0;
  static const double _referenceWidth = 393.0;

  MediaQueryData get mq => MediaQuery.of(this);
  ThemeData get theme => Theme.of(this);
  NavigatorState get nav => Navigator.of(this);

  TextTheme get text => theme.textTheme;
  ColorScheme get color => theme.colorScheme;

  bool get isLightTheme =>
      MediaQuery.platformBrightnessOf(this) == Brightness.light;
  bool get isDarkTheme =>
      MediaQuery.platformBrightnessOf(this) == Brightness.dark;

  Size get size => MediaQuery.sizeOf(this);
  EdgeInsets get padding => MediaQuery.viewPaddingOf(this);
  double get height => size.height;
  double get width => size.width;

  bool get tooSmall => width < 350 || height < 500;

  bool get isAndroid => theme.platform == TargetPlatform.android;
  bool get isiOS => theme.platform == TargetPlatform.iOS;
  bool get isWindows => theme.platform == TargetPlatform.windows;
  bool get isLinux => theme.platform == TargetPlatform.linux;
  bool get isMacOS => theme.platform == TargetPlatform.macOS;
  bool get isDesktop => isWindows || isLinux || isMacOS;
  bool get isMobile => isAndroid || isiOS;

  Size get screenSize => MediaQuery.sizeOf(this);

  // Dynamic scaling functions based on screen size
  double getHeight(double value) {
    double screenHeight = height;
    return (value / _referenceHeight) * screenHeight;
  }

  double getWidth(double value) {
    double screenWidth = width;
    return (value / _referenceWidth) * screenWidth;
  }

  ScreenType get screenType =>
      width > 900 ? ScreenType.desktop : ScreenType.mobile;

  bool get isScreenDesktop => screenType == ScreenType.desktop;

  bool get isScreenMobile => screenType == ScreenType.mobile;
}
