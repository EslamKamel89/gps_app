import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';

class RestaurantSuggestion {
  final String id;
  final String name;
  final double rating; // 0–5
  final String address;
  final String imageUrl;
  final double distanceMiles; // e.g., 2.9

  const RestaurantSuggestion({
    required this.id,
    required this.name,
    required this.rating,
    required this.address,
    required this.imageUrl,
    required this.distanceMiles,
  });

  String get distanceLabel => '${distanceMiles.toStringAsFixed(distanceMiles < 10 ? 1 : 0)} mi';
}

class SuggestionsList extends StatelessWidget {
  const SuggestionsList({
    super.key,
    required this.items,
    required this.onSelect,
    required this.favorites,
    required this.onToggleFavorite,
  });

  final List<RestaurantSuggestion> items;
  final ValueChanged<RestaurantSuggestion> onSelect;
  final Set<String> favorites;
  final ValueChanged<RestaurantSuggestion> onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Container(
        decoration: _box,
        padding: const EdgeInsets.all(14),
        child: Text(
          'No matches. Try a different term.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: GPSColors.mutedText),
        ),
      ).animate().fadeIn(duration: 150.ms);
    }

    return Container(
      decoration: _box,
      constraints: const BoxConstraints(maxHeight: 320),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: items.length,
        separatorBuilder: (_, __) => const Divider(height: 1, color: GPSColors.cardBorder),
        itemBuilder: (context, i) {
          final r = items[i];
          final isFav = favorites.contains(r.id);
          return InkWell(
            onTap: () => onSelect(r),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // thumbnail
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(r.imageUrl, width: 48, height: 48, fit: BoxFit.cover),
                  ),
                  GPSGaps.w12,
                  // main content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // name + distance
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                r.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: GPSColors.text,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            GPSGaps.w8,
                            _DistancePill(label: r.distanceLabel),
                          ],
                        ),
                        GPSGaps.h8,
                        // rating + address
                        Row(
                          children: [
                            const Icon(Icons.star_rounded, size: 16, color: Color(0xFFFFB300)),
                            const SizedBox(width: 4),
                            Text(
                              r.rating.toStringAsFixed(1),
                              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                color: GPSColors.text,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                r.address,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: GPSColors.mutedText,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // favorite button
                  IconButton(
                    tooltip: isFav ? 'Remove from favorites' : 'Add to favorites',
                    onPressed: () => onToggleFavorite(r),
                    icon: Icon(
                      isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                      color: isFav ? Colors.redAccent : GPSColors.primary,
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ).animate().fadeIn(duration: 180.ms).slideY(begin: -.06);
  }

  BoxDecoration get _box => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(14),
    border: Border.all(color: GPSColors.cardBorder),
    boxShadow: [
      BoxShadow(color: Colors.black.withOpacity(.08), blurRadius: 16, offset: const Offset(0, 6)),
    ],
  );
}

class _DistancePill extends StatelessWidget {
  const _DistancePill({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F6FA),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: GPSColors.cardBorder),
      ),
      child: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.labelSmall?.copyWith(color: GPSColors.text, fontWeight: FontWeight.w600),
      ),
    );
  }
}
