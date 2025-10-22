 

import 'package:flutter/material.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';

class DietTagSelector extends StatelessWidget {
  const DietTagSelector({
    super.key,
    required this.allTags,
    required this.selected,
    required this.onChanged,
  });

  final List<String> allTags;
  final Set<String> selected;
  final void Function(String tag, bool isSelected) onChanged;

  @override
  Widget build(BuildContext context) {
    final txt = Theme.of(context).textTheme;

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children:
          allTags.map((tag) {
            final bool isOn = selected.contains(tag);
            return InkWell(
              onTap: () => onChanged(tag, !isOn),
              borderRadius: BorderRadius.circular(18),
              child: Ink(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isOn ? GPSColors.primary.withOpacity(.10) : Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: isOn ? GPSColors.primary : GPSColors.cardBorder),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isOn ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                      size: 16,
                      color: isOn ? GPSColors.primary : GPSColors.mutedText,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      tag,
                      style: txt.labelMedium?.copyWith(
                        color: isOn ? GPSColors.primary : GPSColors.text,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
    );
  }
}
