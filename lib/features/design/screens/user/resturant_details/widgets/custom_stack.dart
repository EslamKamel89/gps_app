import 'package:flutter/material.dart';

class CustomStack extends StatelessWidget {
  const CustomStack({
    super.key,
    required this.child,
    required this.actionWidget,
    required this.enableEdit,
    this.top = 0,
    this.right = 0,
  });
  final Widget child;
  final Widget actionWidget;
  final double? top;
  final double? right;
  final bool enableEdit;
  @override
  Widget build(BuildContext context) {
    if (!enableEdit) return child;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: BoxBorder.all(color: Colors.grey.withOpacity(0.3)),
      ),
      padding: EdgeInsets.only(bottom: 4, left: 4),
      margin: EdgeInsets.all(2),
      child: Stack(
        children: [
          Padding(padding: EdgeInsets.only(top: 15, right: 15), child: child),
          Positioned(top: top, right: right, child: actionWidget),
        ],
      ),
    );
  }
}
