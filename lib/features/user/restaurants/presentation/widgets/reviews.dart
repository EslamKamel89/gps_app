import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';

class Review {
  final String reviewerName;
  final String comment;
  final double rating;
  const Review({required this.reviewerName, required this.comment, required this.rating});
}

class ReviewsSection extends StatelessWidget {
  const ReviewsSection({super.key, required this.reviews});
  final List<Review> reviews;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    if (reviews.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: GPSColors.cardBorder),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          'No reviews yet.',
          style: theme.bodyMedium?.copyWith(color: GPSColors.mutedText),
        ),
      ).animate().fadeIn(duration: 240.ms).slideY(begin: .06);
    }
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: reviews.length,
      separatorBuilder: (_, __) => GPSGaps.h12,
      itemBuilder: (context, i) {
        final r = reviews[i];
        final delay = (80 * i).ms;
        return _ReviewCard(review: r)
            .animate(delay: delay)
            .fadeIn(duration: 260.ms, curve: Curves.easeOutCubic)
            .slideY(begin: .08, curve: Curves.easeOutCubic)
            .scale(begin: const Offset(.98, .98), end: const Offset(1, 1));
      },
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.review});
  final Review review;

  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;
    return Ink(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    review.reviewerName,
                    style: txt.titleSmall?.copyWith(
                      color: GPSColors.text,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                StarRow(rating: review.rating, size: 18),
              ],
            ),
            GPSGaps.h8,
            Text(
              review.comment,
              style: txt.bodyMedium?.copyWith(color: GPSColors.mutedText, height: 1.35),
            ).animate().fadeIn(duration: 200.ms).slideY(begin: .05),
          ],
        ),
      ),
    );
  }
}

class StarRow extends StatelessWidget {
  const StarRow({super.key, required this.rating, this.size = 20, this.color});

  final double rating;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final Color c = color ?? const Color(0xFFFFC107);
    final stars = List<Widget>.generate(5, (i) {
      final idx = i + 1;
      IconData icon;
      if (rating >= idx) {
        icon = Icons.star_rounded;
      } else if (rating >= idx - 0.5) {
        icon = Icons.star_half_rounded;
      } else {
        icon = Icons.star_border_rounded;
      }
      return Icon(icon, size: size, color: c);
    });

    return Row(mainAxisSize: MainAxisSize.min, children: stars);
  }
}
