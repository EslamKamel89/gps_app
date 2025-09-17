import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AlwaysOpenPreview extends StatelessWidget {
  const AlwaysOpenPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Open 24/7', style: text.titleMedium),
          const SizedBox(height: 6),
          Text('All days: 00:00 → 23:59', style: text.bodyMedium),
        ],
      ),
    ).animate().fadeIn().scale(begin: const Offset(0.98, 0.98), end: const Offset(1, 1));
  }
}
