import 'package:flutter/material.dart';
import 'package:gps_app/features/auth/presentation/widgets/operating_hours_picker/time_chip.dart';

class DayRow extends StatelessWidget {
  const DayRow({
    super.key,
    required this.label,
    required this.enabled,
    required this.startText,
    required this.endText,
    required this.onToggle,
    required this.onTapStart,
    required this.onTapEnd,
  });

  final String label;
  final bool enabled;
  final String startText;
  final String endText;
  final ValueChanged<bool> onToggle;
  final VoidCallback onTapStart;
  final VoidCallback onTapEnd;

  @override
  Widget build(BuildContext context) {
    final disabledColor = Theme.of(context).disabledColor;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Switch(value: enabled, onChanged: onToggle),
          SizedBox(width: 42, child: Text(label, style: Theme.of(context).textTheme.titleMedium)),
          const Spacer(),
          TimeChip(
            label: 'Start',
            text: startText,
            onTap: enabled ? onTapStart : null,
            disabledColor: disabledColor,
          ),
          const SizedBox(width: 8),
          TimeChip(
            label: 'End',
            text: endText,
            onTap: enabled ? onTapEnd : null,
            disabledColor: disabledColor,
          ),
        ],
      ),
    );
  }
}
