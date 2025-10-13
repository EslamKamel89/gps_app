import 'package:flutter/material.dart';

class CustomStack extends StatelessWidget {
  const CustomStack({
    super.key,
    required this.child,
    required this.actionWidget,
    this.top,
    this.right,
    this.left,
    this.bottom,
  });
  final Widget child;
  final Widget actionWidget;
  final double? top;
  final double? bottom;
  final double? right;
  final double? left;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(padding: EdgeInsets.only(top: 20), child: child),
        Positioned(top: top, bottom: bottom, right: right, left: left, child: actionWidget),
      ],
    );
  }
}
