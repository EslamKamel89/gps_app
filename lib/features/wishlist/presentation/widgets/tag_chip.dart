import 'package:flutter/material.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';

class TagChip extends StatelessWidget {
  const TagChip({super.key, required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: GPSColors.cardBorder),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: GPSColors.text,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
