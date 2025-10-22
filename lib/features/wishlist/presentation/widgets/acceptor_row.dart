import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/wishlist/entities/acceptor_model.dart';
import 'package:gps_app/features/wishlist/presentation/widgets/logo_box.dart';
import 'package:gps_app/features/wishlist/presentation/widgets/star_row.dart';

class AcceptorRow extends StatelessWidget {
  const AcceptorRow({super.key, required this.acceptor, required this.onTap});
  final AcceptorModel acceptor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Ink(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: GPSColors.cardBorder),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LogoBox().animate().fadeIn(duration: 180.ms).scale(begin: const Offset(.96, .96)),
            GPSGaps.w12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          acceptor.restaurantName,
                          style: txt.titleSmall?.copyWith(
                            color: GPSColors.text,
                            fontWeight: FontWeight.w800,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      StarRow(rating: acceptor.rating, size: 16),
                      GPSGaps.w8,
                      Text(
                        '${acceptor.distanceKm.toStringAsFixed(1)} km',
                        style: txt.labelMedium?.copyWith(color: GPSColors.mutedText),
                      ),
                    ],
                  ),
                  GPSGaps.h8,

                  Text(
                    acceptor.item.name,
                    style: txt.bodyMedium?.copyWith(
                      color: GPSColors.text,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  GPSGaps.h6,
                  Text(
                    acceptor.item.description,
                    style: txt.bodySmall?.copyWith(color: GPSColors.mutedText, height: 1.35),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // GPSGaps.h6,
                  // Wrap(
                  //   spacing: 8,
                  //   runSpacing: 8,
                  //   children: [
                  //     for (final t in acceptor.item.dietTags) TagChip(label: t),
                  //     PriceTag(price: acceptor.item.price),
                  //   ],
                  // ),
                ],
              ),
            ),
            GPSGaps.w8,
            const Icon(Icons.chevron_right_rounded, color: GPSColors.mutedText),
          ],
        ),
      ),
    );
  }
}
