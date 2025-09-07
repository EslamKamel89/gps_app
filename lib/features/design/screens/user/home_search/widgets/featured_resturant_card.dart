import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/design/screens/user/home_search/widgets/meta_row.dart';
import 'package:gps_app/features/design/screens/user/home_search/widgets/verified_badge.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';

class FeaturedRestaurantCard extends StatelessWidget {
  const FeaturedRestaurantCard({super.key, required this.onTap});
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    'https://images.unsplash.com/photo-1466637574441-749b8f19452f?q=80&w=1200&auto=format&fit=crop',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        VerifiedBadge(verified: true),
                        GPSGaps.w8,
                        Text(
                          'GPS Verified',
                          style: Theme.of(
                            context,
                          ).textTheme.labelMedium?.copyWith(
                            color: GPSColors.mutedText,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    GPSGaps.h8,
                    Text(
                      'Farm to Fork',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: GPSColors.text,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    GPSGaps.h8,
                    MetaRow(time: '45–10 min', distance: '2.9 mi'),
                  ],
                ),
              ),
            ],
          ),
        ).animate().fadeIn(duration: 320.ms).slideY(begin: .1),
      ),
    );
  }
}
