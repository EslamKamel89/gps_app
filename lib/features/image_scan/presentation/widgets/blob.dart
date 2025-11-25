import 'package:flutter/material.dart';

class Blob extends StatelessWidget {
  final double size;
  final double opacity;
  final Color color;
  const Blob({super.key, required this.size, required this.opacity, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withOpacity(opacity),
        borderRadius: BorderRadius.circular(size),
        boxShadow: [
          BoxShadow(color: color.withOpacity(opacity * .6), blurRadius: 30, spreadRadius: 8),
        ],
      ),
    );
  }
}
