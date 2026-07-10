import 'package:flutter/material.dart';

abstract final class Responsive {
  static const double _tabletBreakpoint = 600.0;

  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width >= _tabletBreakpoint;
  }
  static double horizontalPadding(BuildContext context) {
     return isTablet(context) ? 48 : 24;
  }
  static double verticalPadding(BuildContext context) {
     return isTablet(context) ? 48 : 24;
  }
}
