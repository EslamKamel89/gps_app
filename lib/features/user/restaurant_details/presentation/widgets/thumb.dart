import 'package:flutter/material.dart';
import 'package:gps_app/core/api_service/end_points.dart';
import 'package:gps_app/core/helpers/print_helper.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/user/restaurant_details/models/restaurant_detailed_model/export.dart';

class ThumbWidget extends StatelessWidget {
  const ThumbWidget({super.key, required this.meal});
  final Meal meal;
  String? imagePath() {
    // pr(meal.images, 'image')?.path;
    final path =
        meal.images?.path?.contains('http') == true
            ? meal.images?.path
            : "${EndPoint.baseUrl}/meal.images?.path";
    return pr(meal.images, 'image')?.path;
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
