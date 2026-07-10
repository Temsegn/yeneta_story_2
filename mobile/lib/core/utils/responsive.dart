import 'package:flutter/material.dart';

/// Max content width matching React (430px). Responsive helpers.
abstract class Responsive {
  static const double maxWidth = 430;

  static bool isNarrow(BuildContext context) {
    return MediaQuery.sizeOf(context).width <= maxWidth;
  }

  static double width(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return w > maxWidth ? maxWidth : w;
  }
}
