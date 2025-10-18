import 'package:flutter/material.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';

class WaitingTip extends StatelessWidget {
  const WaitingTip({super.key});

  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: GPSColors.cardBorder),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline_rounded, color: GPSColors.mutedText, size: 18),
          GPSGaps.w8,
          Expanded(
            child: Text(
              'We’ll notify you when a restaurant accepts your wish.',
              style: txt.bodySmall?.copyWith(color: GPSColors.mutedText, height: 1.35),
            ),
          ),
        ],
      ),
    );
  }
}
