import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';

class SuggestionsList extends StatelessWidget {
  const SuggestionsList({super.key, required this.items, required this.onSelect});
  final List<String> items;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Container(
        decoration: _box,
        padding: const EdgeInsets.all(14),
        child: Text(
          'No matches. Try a different term.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: GPSColors.mutedText),
        ),
      ).animate().fadeIn(duration: 150.ms);
    }

    return Container(
      decoration: _box,
      constraints: const BoxConstraints(maxHeight: 280),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: items.length,
        separatorBuilder: (_, __) => const Divider(height: 1, color: GPSColors.cardBorder),
        itemBuilder: (context, i) {
          final label = items[i];
          return InkWell(
            onTap: () => onSelect(label),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  const Icon(Icons.place_rounded, size: 18, color: GPSColors.primary),
                  GPSGaps.w12,
                  Expanded(
                    child: Text(
                      label,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: GPSColors.text,
                        fontWeight: FontWeight.w600,
                      ),
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
      BoxShadow(color: Colors.black.withOpacity(.08), blurRadius: 16, offset: const Offset(0, 6)),
    ],
  );
}
