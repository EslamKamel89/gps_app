import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';

class RoundSquareButton extends StatelessWidget {
  const RoundSquareButton({super.key, required this.icon, this.onTap});
  final IconData icon;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Ink(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFFE3EFE9),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: GPSColors.cardBorder),
        ),
        child: Icon(icon, color: GPSColors.primary),
      ),
    ).animate().fadeIn().scale(begin: const Offset(.95, .95));
  }
}
