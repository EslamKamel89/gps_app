import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class RoundIcon extends StatelessWidget {
  const RoundIcon({super.key, required this.icon, this.onTap});
  final IconData icon;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white24),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ).animate().fadeIn().scale(begin: const Offset(.95, .95)),
    );
  }
}
