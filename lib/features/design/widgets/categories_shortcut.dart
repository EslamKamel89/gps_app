import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/core/router/app_routes_names.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';

class CategoryItem {
  final String name;
  final String imageUrl;
  const CategoryItem({required this.name, required this.imageUrl});
}

class CategoryShortcutWidget extends StatelessWidget {
  const CategoryShortcutWidget({super.key, required this.items});

  final List<CategoryItem> items;

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
              "Most 💖 Categories",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: GPSColors.text,
                fontWeight: FontWeight.w800,
              ),
            ).animate().fadeIn(duration: 250.ms).slideY(begin: .15),
          ),
          GPSGaps.h12,
          SizedBox(
            height: 112, // circle + label
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              separatorBuilder: (_, __) => GPSGaps.w12,
              itemBuilder: (context, i) {
                final it = items[i];
                return _ShortcutItem(
                      name: it.name,
                      imageUrl: it.imageUrl,
                      onTap: () {
                        Navigator.of(
                          context,
                        ).pushNamed(AppRoutesNames.restaurantDetailScreen);
                      },
                    )
                    // Stagger the entrance a bit for delight
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

/// Single shortcut card: circular image + name below.
class _ShortcutItem extends StatelessWidget {
  const _ShortcutItem({
    required this.name,
    required this.imageUrl,
    required this.onTap,
  });

  final String name;
  final String imageUrl;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: SizedBox(
        width: 84,
        child: Column(
          children: [
            // Circular image
            ClipOval(
                  child: Ink(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: GPSColors.cardBorder),
                      shape: BoxShape.circle,
                    ),
                    child: Image.network(imageUrl, fit: BoxFit.cover),
                  ),
                )
                .animate(onPlay: (c) => c.repeat(reverse: false, count: 1))
                .shimmer(delay: 1200.ms, duration: 1000.ms),
            GPSGaps.h8,
            // Name (single line, ellipsis)
            Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: GPSColors.text,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
