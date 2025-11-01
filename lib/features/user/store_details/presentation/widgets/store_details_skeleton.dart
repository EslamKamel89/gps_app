import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class StoreDetailsSkeleton extends StatelessWidget {
  const StoreDetailsSkeleton({super.key});

  static const _pad = 16.0;
  static const _radius = 16.0;

  @override
  Widget build(BuildContext context) {
    final bg = Theme.of(context).colorScheme.surface;
    final line =
        Theme.of(context).brightness == Brightness.dark
            ? Colors.white.withOpacity(.12)
            : Colors.black.withOpacity(.06);

    return Material(
          color: bg,
          child: ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: _pad,
              vertical: _pad,
            ),
            children: [
              _box(height: 220, radius: 24),

              const SizedBox(height: 16),

              Row(
                children: [
                  _box(height: 28, width: 180),
                  const Spacer(),
                  _circle(size: 36),
                  const SizedBox(width: 8),
                  _circle(size: 36),
                ],
              ),

              const SizedBox(height: 14),

              Row(
                children: [
                  _chip(width: 110),
                  const SizedBox(width: 10),
                  _chip(width: 80),
                ],
              ),

              const SizedBox(height: 16),

              _box(height: 18, width: 220),

              const SizedBox(height: 18),

              _card(
                children: [
                  _sectionHeader(),
                  const SizedBox(height: 12),
                  _iconLine(lineColor: line, labelWidth: 70, valueWidth: 140),
                  _divider(line),
                  _iconLine(lineColor: line, labelWidth: 70, valueWidth: 160),
                ],
              ),

              const SizedBox(height: 16),

              _card(
                children: [
                  _sectionHeader(),
                  const SizedBox(height: 12),
                  _iconLine(lineColor: line, labelWidth: 70, valueWidth: 190),
                  _divider(line),
                  _iconLine(lineColor: line, labelWidth: 70, valueWidth: 150),
                ],
              ),

              const SizedBox(height: 32),
            ],
          ),
        )
        .animate(onPlay: (c) => c.repeat())
        .shimmer(
          duration: 1200.ms,
          colors: [
            Colors.grey.withOpacity(.15),
            Colors.grey.withOpacity(.30),
            Colors.grey.withOpacity(.15),
          ],
        );
  }

  static Widget _card({required List<Widget> children}) => Container(
    padding: const EdgeInsets.all(_pad),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(_radius),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.black.withOpacity(.03), Colors.black.withOpacity(.02)],
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    ),
  );

  static Widget _sectionHeader() => Row(
    children: [
      _circle(size: 28),
      const SizedBox(width: 8),
      _box(height: 18, width: 90),
    ],
  );

  static Widget _iconLine({
    required Color lineColor,
    double labelWidth = 60,
    double valueWidth = 160,
  }) => Row(
    children: [
      _circle(size: 28),
      const SizedBox(width: 12),
      Expanded(
        child: Row(
          children: [
            _box(height: 14, width: labelWidth),
            const SizedBox(width: 16),
            _box(height: 14, width: valueWidth),
          ],
        ),
      ),
    ],
  );

  static Widget _divider(Color c) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Container(height: 1, color: c),
  );

  static Widget _chip({double width = 90}) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(24),
      color: Colors.grey.withOpacity(.14),
    ),
    child: _box(height: 12, width: width, radius: 8),
  );

  static Widget _circle({double size = 32}) =>
      _box(height: size, width: size, radius: size);

  static Widget _box({
    double? height,
    double? width,
    double radius = _radius,
  }) => Container(
    height: height,
    width: width,
    decoration: BoxDecoration(
      color: Colors.grey.withOpacity(.18),
      borderRadius: BorderRadius.circular(radius),
    ),
  );
}
