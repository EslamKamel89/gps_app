import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/core/helpers/image_url.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/search/models/suggestion_model/suggestion_model.dart';

class SuggestionsList extends StatelessWidget {
  const SuggestionsList({
    super.key,
    required this.items,
    required this.onSelect,
    required this.favorites,
    required this.onToggleFavorite,
    this.isScrollable = true,
  });

  final List<SuggestionModel> items;
  final ValueChanged<SuggestionModel> onSelect;
  final Set<String> favorites;
  final ValueChanged<SuggestionModel> onToggleFavorite;
  final bool isScrollable;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Container(
        decoration: _box,
        padding: const EdgeInsets.all(14),
        child: Text(
          'No matches. Try a different term.',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: GPSColors.mutedText),
        ),
      ).animate().fadeIn(duration: 150.ms);
    }

    return Container(
      decoration: isScrollable ? _box : null,
      constraints: isScrollable ? BoxConstraints(maxHeight: 320) : null,
      child: ListView.separated(
        physics: isScrollable ? null : NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: items.length,
        separatorBuilder:
            (_, __) => const Divider(height: 1, color: GPSColors.cardBorder),
        itemBuilder: (context, i) {
          final r = items[i];

          return InkWell(
            onTap: () => onSelect(r),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: getImageUrl(r.image),
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,

                      placeholder:
                          (context, url) => Container(
                            width: 48,
                            height: 48,
                            alignment: Alignment.center,
                            color: Colors.grey.shade200,
                            child: const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),

                      errorWidget:
                          (context, url, error) => Container(
                            width: 48,
                            height: 48,
                            color: Colors.grey.shade300,
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.error,
                              size: 20,
                              color: Colors.red,
                            ),
                          ),
                    ),
                  ),
                  GPSGaps.w12,

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                r.name ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.copyWith(
                                  color: GPSColors.text,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            GPSGaps.w8,
                            _DistancePill(
                              label: '${r.distance?.toString() ?? ''} ml',
                            ),
                          ],
                        ),
                        GPSGaps.h8,

                        Row(
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              size: 16,
                              color: Color(0xFFFFB300),
                            ),
                            const SizedBox(width: 4),

                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                r.address ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(
                                  context,
                                ).textTheme.labelMedium?.copyWith(
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
      BoxShadow(
        color: Colors.black.withOpacity(.08),
        blurRadius: 16,
        offset: const Offset(0, 6),
      ),
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
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: GPSColors.text,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
