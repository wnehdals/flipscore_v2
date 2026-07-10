import 'package:flutter/material.dart';

class VerticalScrollView extends StatelessWidget {
  const VerticalScrollView({
    super.key,
    required this.children,
    this.padding,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.controller,
  });

  final List<Widget> children;
  final EdgeInsetsGeometry? padding;
  final CrossAxisAlignment crossAxisAlignment;
  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: controller,
      padding: padding,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        children: children,
      ),
    );
  }
}
