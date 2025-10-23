import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';

class PrimaryActionRow extends StatelessWidget {
  const PrimaryActionRow({super.key, required this.isAccepted, required this.onTap});
  final void Function()? onTap;
  final bool isAccepted;

  @override
  Widget build(BuildContext context) {
    final label = 'View matches';

    return Row(
      children: [
        ElevatedButton.icon(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: GPSColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),
          icon: Icon(Icons.expand_less_rounded, size: 18),
          label: Text(label, style: const TextStyle(fontWeight: FontWeight.w800)),
        ).animate().fadeIn(duration: 200.ms).scale(begin: const Offset(.98, .98)),
      ],
    );
  }
}
