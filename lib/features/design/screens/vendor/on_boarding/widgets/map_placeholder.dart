// features/vendor_onboarding/widgets/map_placeholder.dart

import 'package:flutter/material.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';

class MapPlaceholder extends StatelessWidget {
  final double latitude;
  final double longitude;
  final VoidCallback onTap;

  const MapPlaceholder({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Location on Map',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: GPSColors.text,
          ),
        ),
        GPSGaps.h8,
        Stack(
          children: [
            GestureDetector(
              onTap: onTap,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  'https://media.wired.com/photos/59269cd37034dc5f91bec0f1/3:2/w_2240,c_limit/GoogleMapTA.jpg',
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  loadingBuilder: (ctx, child, progress) {
                    if (progress == null) return child;
                    return Container(
                      color: GPSColors.cardBorder,
                      child: const Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    );
                  },
                  errorBuilder:
                      (ctx, err, st) => Container(
                        color: GPSColors.cardBorder,
                        child: const Center(
                          child: Icon(
                            Icons.map_outlined,
                            color: GPSColors.mutedText,
                          ),
                        ),
                      ),
                ),
              ),
            ),
          ],
        ),
        GPSGaps.h8,
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                icon: const Icon(Icons.my_location_rounded, size: 16),
                label: const Text('Use Current Location'),
                onPressed: onTap,
              ),
            ),
            // GPSGaps.w8,
            // OutlinedButton.icon(
            //   style: OutlinedButton.styleFrom(
            //     padding: const EdgeInsets.symmetric(vertical: 12),
            //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            //   ),
            //   icon: const Icon(Icons.edit_location_alt_rounded, size: 16),
            //   label: const Text('Set Manually'),
            //   onPressed: onTap,
            // ),
          ],
        ),
      ],
    );
  }
}
