import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CircleBack extends StatelessWidget {
  const CircleBack({super.key, this.onTap});
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white24),
          ),
          child: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 18,
          ),
        ).animate().fadeIn().scale(begin: const Offset(.95, .95)),
      ),
    );
  }
}
