import 'package:flutter/material.dart';
import 'package:gps_app/features/design/screens/user/resturant_details/widgets/icon_action.dart';
import 'package:gps_app/features/design/screens/user/resturant_details/widgets/pill.dart';
import 'package:gps_app/features/design/screens/user/resturant_details/widgets/price_badge.dart';
import 'package:gps_app/features/design/screens/user/resturant_details/widgets/thumb.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/user/restaurants/presentation/widgets/helpers.dart';

class MenuItemCard extends StatelessWidget {
  const MenuItemCard({super.key, required this.item, required this.heroTag});
  final MenuItem item;
  final String heroTag;

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
              ThumbWidget(heroTag: heroTag),
              // .animate().fadeIn(duration: 200.ms),
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
                            item.name,
                            style: textTheme.titleMedium?.copyWith(
                              color: GPSColors.text,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        PriceBadge(price: item.price),
                      ],
                    ),
                    GPSGaps.h8,
                    Text(
                      item.description,
                      style: textTheme.bodyMedium?.copyWith(
                        color: GPSColors.mutedText,
                        height: 1.35,
                      ),
                    ),
                    GPSGaps.h8,
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        if (item.isSpicy)
                          const Pill(label: 'Spicy', icon: Icons.local_fire_department_rounded),
                        for (final t in item.tags) Pill(label: t),
                      ],
                    ),
                    GPSGaps.h12,
                    Row(
                      children: [
                        // Expanded(child: _AddButton(label: 'Add to order', onTap: () {})),
                        Spacer(),
                        // GPSGaps.w12,
                        IconAction(icon: Icons.favorite_border_rounded, onTap: () {}),
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
