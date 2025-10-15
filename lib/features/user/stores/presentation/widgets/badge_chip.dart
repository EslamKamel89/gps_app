import 'package:flutter/material.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';

class BadgeChip extends StatelessWidget {
  const BadgeChip({super.key, required this.label, this.icon, this.iconColor = GPSColors.primary});

  final String label;
  final IconData? icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: GPSColors.cardBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon ?? Icons.check_circle, size: 16, color: iconColor),
          GPSGaps.w8,
          Text(
            label,
            style: text.labelMedium?.copyWith(color: GPSColors.text, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
