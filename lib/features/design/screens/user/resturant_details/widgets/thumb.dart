import 'package:flutter/material.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';

class ThumbWidget extends StatelessWidget {
  const ThumbWidget({super.key, required this.heroTag});
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: heroTag,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          'https://images.unsplash.com/photo-1544025162-d76694265947?q=80&w=800&auto=format&fit=crop',
          width: 86,
          height: 86,
          fit: BoxFit.cover,
          errorBuilder:
              (_, __, ___) => Container(
                width: 86,
                height: 86,
                color: GPSColors.cardBorder,
                alignment: Alignment.center,
                child: const Icon(
                  Icons.image_not_supported_outlined,
                  color: GPSColors.mutedText,
                ),
              ),
        ),
      ),
    );
  }
}
