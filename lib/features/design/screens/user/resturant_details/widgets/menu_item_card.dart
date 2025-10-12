import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/design/screens/user/resturant_details/widgets/icon_action.dart';
import 'package:gps_app/features/design/screens/user/resturant_details/widgets/price_badge.dart';
import 'package:gps_app/features/design/screens/user/resturant_details/widgets/thumb.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/user/restaurants/models/restaurant_detailed_model/export.dart';

class MenuItemCard extends StatelessWidget {
  const MenuItemCard({super.key, required this.meal});
  final Meal meal;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {},
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: GPSColors.cardBorder),
          boxShadow: const [
            BoxShadow(
              blurRadius: 14,
              spreadRadius: -4,
              offset: Offset(0, 6),
              color: Color(0x1A000000),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ThumbWidget(meal: meal).animate().fadeIn(duration: 200.ms),
              GPSGaps.w12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            meal.name ?? '',
                            style: textTheme.titleMedium?.copyWith(
                              color: GPSColors.text,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        PriceBadge(price: double.parse(meal.price ?? '0')),
                      ],
                    ),
                    GPSGaps.h8,
                    Text(
                      meal.description ?? '',
                      style: textTheme.bodyMedium?.copyWith(
                        color: GPSColors.mutedText,
                        height: 1.35,
                      ),
                    ),

                    GPSGaps.h12,
                    Row(
                      children: [
                        // Chip(label: Text(meal.)),
                        Spacer(),
                        // GPSGaps.w12,
                        IconAction(
                          icon: Icons.favorite_border_rounded,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
