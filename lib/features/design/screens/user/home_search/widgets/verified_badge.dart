import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';

class VerifiedBadge extends StatelessWidget {
  const VerifiedBadge({super.key, required this.verified});
  final bool verified;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: 200.ms,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: verified ? GPSColors.cardSelected : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: GPSColors.cardBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.verified_rounded,
            size: 16,
            color: verified ? GPSColors.primary : GPSColors.mutedText,
          ),
        ],
      ),
    );
  }
}
