import 'package:flutter/material.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';

class SuggestionBullet extends StatelessWidget {
  const SuggestionBullet({super.key, required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: GPSColors.mutedText),
          GPSGaps.w8,
          Expanded(
            child: Text(
              text,
              style: txt.bodySmall?.copyWith(color: GPSColors.mutedText, height: 1.35),
            ),
          ),
        ],
      ),
    );
  }
}
