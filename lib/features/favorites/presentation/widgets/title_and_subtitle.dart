import 'package:flutter/material.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';

class TitleAndSubtitle extends StatelessWidget {
  final String title;
  final String subtitle;
  const TitleAndSubtitle({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title - 1 line
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: GPSColors.text,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        GPSGaps.h4,
        // Subtitle (address) - 2 lines
        Text(
          subtitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: GPSColors.mutedText,
            fontSize: 13,
            height: 1.2,
          ),
        ),
      ],
    );
  }
}
