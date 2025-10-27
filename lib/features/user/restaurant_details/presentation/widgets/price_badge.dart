import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PriceBadge extends StatelessWidget {
  const PriceBadge({super.key, required this.price});
  final double price;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF111827), Color(0xFF334155)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '\$${price.toStringAsFixed(2)}',
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
      ),
    ).animate().fadeIn(duration: 200.ms).scale(begin: const Offset(.95, .95));
  }
}
