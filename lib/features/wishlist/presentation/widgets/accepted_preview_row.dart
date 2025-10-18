import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/wishlist/entities/acceptor_entity.dart';
import 'package:gps_app/features/wishlist/presentation/widgets/mini_restaurant_chip.dart';

class AcceptedPreviewRow extends StatelessWidget {
  const AcceptedPreviewRow({super.key, required this.acceptors});
  final List<AcceptorEntity> acceptors;

  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;
    final preview = acceptors.take(3).toList();
    final remaining = acceptors.length - preview.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final a in preview) MiniRestaurantChip(name: a.restaurantName),
            if (remaining > 0) MiniRestaurantChip(name: '+$remaining more'),
          ],
        ).animate().fadeIn(duration: 220.ms).slideY(begin: .04),
        GPSGaps.h8,
        Text(
          'Matched restaurants can satisfy this wish with specific menu items.',
          style: txt.bodySmall?.copyWith(color: GPSColors.mutedText),
        ),
      ],
    );
  }
}
