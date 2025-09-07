import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/core/router/app_routes_names.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';

class RestaurantItem {
  final String name;
  final String imageUrl;
  final double rating;
  final String cuisine;
  const RestaurantItem({
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.cuisine,
  });
}

class MostLovedRestaurantsWidget extends StatelessWidget {
  const MostLovedRestaurantsWidget({super.key, required this.items});

  final List<RestaurantItem> items;

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
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: GPSColors.text,
                fontWeight: FontWeight.w800,
              ),
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
                        Navigator.of(
                          context,
                        ).pushNamed(AppRoutesNames.restaurantDetailScreen);
                      },
                    )
                    .animate()
                    .fadeIn(duration: 280.ms, delay: (i * 60).ms)
                    .slideX(begin: .08);
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

  final RestaurantItem restaurant;
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
                        child: Image.network(
                          restaurant.imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: GPSColors.primary,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              restaurant.rating.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Icon(
                              Icons.star,
                              color: Colors.white,
                              size: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
                .animate(onPlay: (c) => c.repeat(reverse: false, count: 1))
                .shimmer(delay: 1200.ms, duration: 1000.ms),
            GPSGaps.h8,
            // Restaurant name
            Text(
              restaurant.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: GPSColors.text,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
            GPSGaps.h8,
            Text(
              restaurant.cuisine,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: GPSColors.mutedText,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
