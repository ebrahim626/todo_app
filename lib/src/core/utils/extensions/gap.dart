import 'package:flutter/cupertino.dart';

extension PaddingExtension on num {
  /// Creates a vertical gap with the given height.
  SizedBox get ph => SizedBox(height: toDouble());

  /// Creates a horizontal gap with the given width.
  SizedBox get pw => SizedBox(width: toDouble());
}