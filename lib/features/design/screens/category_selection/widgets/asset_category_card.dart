import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';

class AssetCategoryCard extends StatelessWidget {
  const AssetCategoryCard({
    super.key,
    required this.label,
    required this.description,
    required this.assetPath,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String description; // NEW
  final String assetPath;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final borderColor = selected ? GPSColors.primary : GPSColors.cardBorder;
    final bg = selected ? GPSColors.cardSelected : Colors.white;

    final image = ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.asset(assetPath, fit: BoxFit.contain, width: double.infinity, height: 70),
    );

    final card = Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1.6),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              image
                  .animate(target: selected ? 1 : 0)
                  .scaleXY(begin: 1, end: 1.04, duration: 180.ms),
              GPSGaps.h12,
              Text(
                label,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: GPSColors.text,
                  fontWeight: FontWeight.w600,
                ),
              ),
              GPSGaps.h8,
              Text(
                description,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: GPSColors.text.withOpacity(.70), // lighter
                  height: 1.25,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return card
        .animate(onPlay: (c) => c.forward())
        .then()
        .shake(hz: selected ? 2 : 0, duration: selected ? 200.ms : 1.ms);
  }
}
