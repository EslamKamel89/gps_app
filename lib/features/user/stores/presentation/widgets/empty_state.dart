import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
                  Icons.inventory_2_outlined,
                  size: 42,
                  color: GPSColors.mutedText,
                )
                .animate()
                .fadeIn(duration: 250.ms)
                .scale(begin: const Offset(.9, .9)),
            GPSGaps.h12,
            Text(
              message,
              textAlign: TextAlign.center,
              style: txt.bodyMedium?.copyWith(color: GPSColors.mutedText),
            ).animate().fadeIn(duration: 260.ms).slideY(begin: .05),
          ],
        ),
      ),
    );
  }
}
