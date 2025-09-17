import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/auth/presentation/widgets/operating_hours_picker/time_box.dart';

class AllDaysSameEditor extends StatelessWidget {
  const AllDaysSameEditor({
    super.key,
    required this.start,
    required this.end,
    required this.onPickStart,
    required this.onPickEnd,
  });

  final TimeOfDay start;
  final TimeOfDay end;
  final VoidCallback onPickStart;
  final VoidCallback onPickEnd;

  String _fmt(TimeOfDay t) =>
      "${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}";

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Same hours for all days', style: text.titleMedium),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: TimeBox(label: 'Start', value: _fmt(start), onTap: onPickStart)),
            const SizedBox(width: 10),
            Expanded(child: TimeBox(label: 'End', value: _fmt(end), onTap: onPickEnd)),
          ],
        ),
      ],
    ).animate().fadeIn().slideY(begin: 0.1, end: 0);
  }
}
