import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PlaceCardSkeleton extends StatelessWidget {
  const PlaceCardSkeleton({super.key});

  Color _base(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? Colors.grey.shade800
          : Colors.grey.shade300;

  Widget _line(BuildContext context, {double height = 12, double width = 120}) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: _base(context),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final base = _base(context);

    return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Theme.of(context).dividerColor.withOpacity(0.2),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // leading thumbnail
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: base,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),

              const SizedBox(width: 12),

              // text area
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _line(context, height: 14, width: 190), // title
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        // small star circle
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: base,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        _line(context, width: 120), // subtitle
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // trailing distance chip
              Container(
                height: 28,
                width: 92,
                decoration: BoxDecoration(
                  color: base,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ],
          ),
        )
        // shimmer effect over the whole card
        .animate(
          onPlay: (c) => c.repeat(), // keep shimmering while loading
        )
        .shimmer(
          duration: const Duration(milliseconds: 1400),
          colors: [
            base.withOpacity(0.55), // start
            base.withOpacity(0.35), // highlight
            base.withOpacity(0.55), // end
          ],
        );
  }
}

class PlaceCardSkeletonList extends StatelessWidget {
  const PlaceCardSkeletonList({super.key, this.count = 6});
  final int count;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.all(12),
      itemBuilder: (_, __) => const PlaceCardSkeleton(),
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemCount: count,
    );
  }
}
