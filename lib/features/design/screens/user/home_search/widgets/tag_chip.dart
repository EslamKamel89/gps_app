import 'package:flutter/material.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';

class TagChip extends StatelessWidget {
  const TagChip({super.key, required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFE3EFE9),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: GPSColors.cardBorder),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: GPSColors.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
