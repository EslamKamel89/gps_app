import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/wishlist/presentation/widgets/suggestion_chip.dart';
import 'package:gps_app/features/wishlist/presentation/widgets/suggestions_bullet.dart';

class WaitingSuggestions extends StatelessWidget {
  const WaitingSuggestions({super.key});

  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: GPSColors.cardBorder),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.lightbulb_outline_rounded, color: GPSColors.mutedText, size: 20),
              GPSGaps.w12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'No matches yet',
                      style: txt.titleSmall?.copyWith(
                        color: GPSColors.text,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    GPSGaps.h6,
                    Text(
                      'Try refining your wish so restaurants can match it faster.',
                      style: txt.bodySmall?.copyWith(color: GPSColors.mutedText, height: 1.35),
                    ),
                    GPSGaps.h10,

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        SuggestionBullet(
                          icon: Icons.place_outlined,
                          text: 'Add a location hint (e.g., “near Zamalek”).',
                        ),
                        SuggestionBullet(
                          icon: Icons.schedule_outlined,
                          text: 'Add timing (e.g., “tonight” or “lunch”).',
                        ),
                        SuggestionBullet(
                          icon: Icons.sell_outlined,
                          text: 'Add dietary tags (vegan, gluten-free, organic).',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ).animate().fadeIn(duration: 220.ms).slideY(begin: .06),

        GPSGaps.h12,

        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            SuggestionChip(icon: Icons.place_outlined, label: 'Add location', onTap: () {}),
            SuggestionChip(icon: Icons.schedule_outlined, label: 'Add time', onTap: () {}),
            SuggestionChip(icon: Icons.sell_outlined, label: 'Add tags', onTap: () {}),
          ],
        ).animate().fadeIn(duration: 220.ms).slideY(begin: .04),
      ],
    );
  }
}
