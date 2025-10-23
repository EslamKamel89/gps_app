import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';

class StatusPill extends StatelessWidget {
  const StatusPill({super.key, required this.status, required this.count});
  final int status;
  final int count;

  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;

    final bool accepted = status == 1;
    final Color bg =
        accepted ? GPSColors.primary.withOpacity(.12) : const Color(0xFFECEFF1);
    final Color fg = accepted ? GPSColors.primary : GPSColors.mutedText;

    final String label = accepted ? 'Accepted by $count' : 'Waiting';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: GPSColors.cardBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            accepted
                ? Icons.check_circle_rounded
                : Icons.hourglass_bottom_rounded,
            size: 16,
            color: fg,
          ),
          GPSGaps.w8,
          Text(
            label,
            style: txt.labelMedium?.copyWith(
              color: fg,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 180.ms).scale(begin: const Offset(.96, .96));
  }
}
