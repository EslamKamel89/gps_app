import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';

class DietCard extends StatelessWidget {
  const DietCard({
    super.key,
    required this.emoji,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String emoji;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final borderColor = selected ? GPSColors.primary : GPSColors.cardBorder;
    final bg = selected ? GPSColors.cardSelected : Colors.white;

    final card = Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1.6),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 42),
            ).animate(target: selected ? 1 : 0).scaleXY(begin: 1, end: 1.08, duration: 180.ms),
            GPSGaps.h12,
            Text(
              label,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: GPSColors.text, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );

    return card
        .animate(onPlay: (controller) => controller.forward())
        // .shadow(color: const Color(0x1A000000), begin: 0, end: 12, duration: 300.ms, curve: Curves.easeOut)
        .then()
        .shake(hz: selected ? 2 : 0, duration: selected ? 200.ms : 1.ms); // subtle tap feedback
  }
}
