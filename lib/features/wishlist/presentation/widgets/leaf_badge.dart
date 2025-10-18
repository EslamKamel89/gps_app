import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';

class LeafBadge extends StatelessWidget {
  const LeafBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: GPSColors.primary.withOpacity(.10),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: GPSColors.cardBorder),
      ),
      child: const Icon(Icons.eco_rounded, color: GPSColors.primary, size: 20),
    ).animate().fadeIn(duration: 180.ms).scale(begin: const Offset(.96, .96));
  }
}
