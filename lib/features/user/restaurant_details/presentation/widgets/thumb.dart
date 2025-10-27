import 'package:flutter/material.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/user/restaurant_details/models/restaurant_detailed_model/export.dart';

class ThumbWidget extends StatelessWidget {
  const ThumbWidget({super.key, required this.meal});
  final Meal meal;
  String? imagePath() {
    // if (meal.images?.isNotEmpty == true) {
    //   return meal.images![0].path;
    // }
    // return null;
    return meal.images?.path;
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        "${imagePath()}",
        width: 86,
        height: 86,
        fit: BoxFit.cover,
        errorBuilder:
            (_, __, ___) => Container(
              width: 86,
              height: 86,
              color: GPSColors.cardBorder,
              alignment: Alignment.center,
              child: const Icon(Icons.image_not_supported_outlined, color: GPSColors.mutedText),
            ),
      ),
    );
  }
}
