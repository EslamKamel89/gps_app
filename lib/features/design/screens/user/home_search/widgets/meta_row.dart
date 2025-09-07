import 'package:flutter/material.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';

class MetaRow extends StatelessWidget {
  const MetaRow({super.key, required this.time, required this.distance});
  final String time;
  final String distance;

  @override
  Widget build(BuildContext context) {
    TextStyle s = Theme.of(context).textTheme.labelMedium!.copyWith(
      color: GPSColors.mutedText,
      fontWeight: FontWeight.w600,
    );
    return Row(
      children: [
        const Icon(Icons.schedule, size: 16, color: GPSColors.mutedText),
        GPSGaps.w8,
        Text(time, style: s),
        GPSGaps.w12,
        const Icon(Icons.place_rounded, size: 16, color: GPSColors.mutedText),
        GPSGaps.w8,
        Text(distance, style: s),
      ],
    );
  }
}
