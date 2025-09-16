import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';

class GpsLabeledField extends StatelessWidget {
  const GpsLabeledField({super.key, required this.label, required this.child});
  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: GPSColors.text,
            fontWeight: FontWeight.w700,
          ),
        ),
        GPSGaps.h8,
        child,
      ],
    ).animate().fadeIn(duration: 260.ms).slideY(begin: .10);
  }
}
