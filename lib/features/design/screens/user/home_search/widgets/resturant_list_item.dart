import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/design/screens/user/home_search/widgets/meta_row.dart';
import 'package:gps_app/features/design/screens/user/home_search/widgets/verified_badge.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';

class RestaurantListItem extends StatelessWidget {
  const RestaurantListItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.distance,
    required this.verified,
    required this.imageUrl,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String time;
  final String distance;
  final bool verified;
  final String imageUrl;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: GPSColors.cardBorder),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
                child: SizedBox(
                  width: 96,
                  height: 96,
                  child: Image.network(imageUrl, fit: BoxFit.cover),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (verified) const VerifiedBadge(verified: true),
                          if (verified) ...[
                            GPSGaps.w8,
                            Text(
                              'GPS Verified',
                              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                color: GPSColors.mutedText,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ],
                      ),
                      GPSGaps.h8,
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: GPSColors.text,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      GPSGaps.h8,
                      Text(
                        subtitle,
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: GPSColors.mutedText),
                      ),
                      GPSGaps.h8,
                      MetaRow(time: time, distance: distance),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ).animate().fadeIn(duration: 320.ms).slideX(begin: .1),
      ),
    );
  }
}
