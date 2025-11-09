import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';

class LoadingFavoritesPlaceholder extends StatelessWidget {
  final int count;

  const LoadingFavoritesPlaceholder({super.key, this.count = 3});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(count, (i) {
        return _LoadingFavoriteCard(index: i);
      }),
    );
  }
}

class _LoadingFavoriteCard extends StatelessWidget {
  final int index;
  const _LoadingFavoriteCard({required this.index});

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(16);

    return Container(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: GPSColors.cardBorder),
            borderRadius: borderRadius,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _CircleShimmer(diameter: 52),
                  GPSGaps.w12,

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _ShimmerBox(
                          width: double.infinity,
                          height: 16,
                          radius: 6,
                        ),
                        GPSGaps.h6,
                        _ShimmerBox(
                          width: double.infinity,
                          height: 12,
                          radius: 6,
                        ),
                        GPSGaps.h4,
                        _ShimmerBox(
                          width: MediaQuery.sizeOf(context).width * 0.35,
                          height: 12,
                          radius: 6,
                        ),
                      ],
                    ),
                  ),
                  GPSGaps.w8,

                  _ChipShimmer(),
                  GPSGaps.w8,

                  _IconShimmer(size: 24),
                ],
              ),

              GPSGaps.h12,
              Column(
                children: [
                  _DetailRowShimmer(),
                  GPSGaps.h8,
                  _DetailRowShimmer(),
                  GPSGaps.h8,
                  _DetailRowShimmer(),
                  GPSGaps.h8,
                  _DetailRowShimmer(multiline: true),
                  GPSGaps.h8,
                  _DetailRowShimmer(short: true),
                ],
              ),
            ],
          ),
        )
        .animate(delay: (index * 60).ms)
        .fadeIn(duration: 250.ms)
        .move(
          begin: const Offset(0, 12),
          end: Offset.zero,
          duration: 300.ms,
          curve: Curves.easeOutCubic,
        );
  }
}

class _ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final double radius;
  final EdgeInsetsGeometry? margin;

  const _ShimmerBox({
    required this.width,
    required this.height,
    this.radius = 8,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final base = Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: GPSColors.cardSelected.withOpacity(0.5),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: GPSColors.cardBorder),
      ),
    );

    return base.animate(onPlay: (c) => c.repeat()).shimmer(duration: 1200.ms);
  }
}

class _CircleShimmer extends StatelessWidget {
  final double diameter;
  const _CircleShimmer({required this.diameter});

  @override
  Widget build(BuildContext context) {
    final base = Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        color: GPSColors.cardSelected.withOpacity(0.5),
        shape: BoxShape.circle,
        border: Border.all(color: GPSColors.cardBorder),
      ),
      child: Icon(
        Icons.image,
        size: diameter * 0.42,
        color: GPSColors.mutedText,
      ),
    );

    return base.animate(onPlay: (c) => c.repeat()).shimmer(duration: 1200.ms);
  }
}

class _IconShimmer extends StatelessWidget {
  final double size;
  const _IconShimmer({this.size = 20});

  @override
  Widget build(BuildContext context) {
    final base = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: GPSColors.cardSelected.withOpacity(0.5),
        borderRadius: BorderRadius.circular(size * 0.25),
        border: Border.all(color: GPSColors.cardBorder),
      ),
    );

    return base.animate(onPlay: (c) => c.repeat()).shimmer(duration: 1200.ms);
  }
}

class _ChipShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final base = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      decoration: BoxDecoration(
        color: GPSColors.accent.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: GPSColors.cardBorder),
      ),
      child: const SizedBox.shrink(),
    );

    return base.animate(onPlay: (c) => c.repeat()).shimmer(duration: 1200.ms);
  }
}

class _DetailRowShimmer extends StatelessWidget {
  final bool multiline;
  final bool short;

  const _DetailRowShimmer({this.multiline = false, this.short = false});

  @override
  Widget build(BuildContext context) {
    final label = _ShimmerBox(width: 56, height: 12, radius: 6);
    final valueWidth =
        short
            ? MediaQuery.sizeOf(context).width * 0.18
            : multiline
            ? MediaQuery.sizeOf(context).width * 0.55
            : MediaQuery.sizeOf(context).width * 0.38;

    final value = _ShimmerBox(width: valueWidth, height: 12, radius: 6);

    return Row(
      crossAxisAlignment:
          multiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        _IconShimmer(size: 18),
        GPSGaps.w8,
        Expanded(
          child: Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              label,
              value,
              if (multiline)
                _ShimmerBox(width: valueWidth * 0.8, height: 12, radius: 6),
            ],
          ),
        ),
      ],
    );
  }
}
