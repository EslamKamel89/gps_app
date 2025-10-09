import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/core/router/app_routes_names.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/user/restaurants/models/restaurant_main_data.dart';

class MostLovedRestaurantsWidget extends StatelessWidget {
  const MostLovedRestaurantsWidget({super.key, required this.items});

  final List<RestaurantMainData> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Section title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Most ❤️ Restaurants",
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: GPSColors.text, fontWeight: FontWeight.w800),
            ).animate().fadeIn(duration: 250.ms).slideY(begin: .15),
          ),
          GPSGaps.h12,
          SizedBox(
            height: 140,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              separatorBuilder: (_, __) => GPSGaps.w12,
              itemBuilder: (context, i) {
                final it = items[i];
                return _RestaurantItem(
                  restaurant: it,
                  onTap: () {
                    Navigator.of(context).pushNamed(AppRoutesNames.restaurantDetailScreen);
                  },
                ).animate().fadeIn(duration: 280.ms, delay: (i * 60).ms).slideX(begin: .08);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _RestaurantItem extends StatelessWidget {
  const _RestaurantItem({required this.restaurant, required this.onTap});

  final RestaurantMainData restaurant;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: SizedBox(
        child: Column(
          children: [
            Stack(
                  children: [
                    ClipOval(
                      child: Ink(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: GPSColors.cardBorder),
                          shape: BoxShape.circle,
                        ),
                        child: Image.network(restaurant.path ?? '', fit: BoxFit.cover),
                      ),
                    ),
                  ],
                )
                .animate(onPlay: (c) => c.repeat(reverse: false, count: 1))
                .shimmer(delay: 1200.ms, duration: 1000.ms),
            GPSGaps.h8,
            // Restaurant name
            Text(
              restaurant.vendorName ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: GPSColors.text,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
