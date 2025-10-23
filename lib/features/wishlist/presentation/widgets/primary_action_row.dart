import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';

class PrimaryActionRow extends StatelessWidget {
  const PrimaryActionRow({super.key, required this.isAccepted});

  final bool isAccepted;

  @override
  Widget build(BuildContext context) {
    final label = 'View matches';

    return Row(
      children: [
        ElevatedButton.icon(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: GPSColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),
          icon: Icon(true ? Icons.expand_less_rounded : Icons.expand_more_rounded, size: 18),
          label: Text(label, style: const TextStyle(fontWeight: FontWeight.w800)),
        ).animate().fadeIn(duration: 200.ms).scale(begin: const Offset(.98, .98)),
        GPSGaps.w12,
        if (!isAccepted)
          OutlinedButton.icon(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: GPSColors.text,
              side: const BorderSide(color: GPSColors.cardBorder),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
            icon: const Icon(Icons.edit_outlined, size: 18),
            label: const Text('Improve wish', style: TextStyle(fontWeight: FontWeight.w700)),
          ).animate().fadeIn(duration: 220.ms).slideY(begin: .04),
      ],
    );
  }
}
