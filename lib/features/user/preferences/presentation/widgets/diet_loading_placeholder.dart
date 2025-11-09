import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';

class DietCardPlaceholder extends StatelessWidget {
  const DietCardPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    final borderColor = GPSColors.cardBorder;
    final bg = Colors.white;

    final skeleton = Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1.6),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: double.infinity,
              height: 40,
              color: Colors.black12,
            ),
          ),
          GPSGaps.h12,
          Container(
            height: 16,
            width: 90,
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ],
      ),
    );

    // Shimmer loop
    return skeleton
        .animate(onPlay: (c) => c.repeat())
        .shimmer(duration: 1200.ms);
  }
}
