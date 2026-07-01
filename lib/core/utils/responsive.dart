import 'package:flutter/material.dart';

abstract final class Responsive {
  static const double _tabletBreakpoint = 600.0;

  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width >= _tabletBreakpoint;
  }

  static double getDp (BuildContext context, double value) => 
    isTablet(context) ? value + 12.0 : value;
 }
