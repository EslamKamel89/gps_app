import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/auth/presentation/widgets/operating_hours_picker/day_row.dart';
import 'package:gps_app/features/auth/presentation/widgets/operating_hours_picker/operating_hour_picker.dart';

class CustomDaysEditor extends StatelessWidget {
  const CustomDaysEditor({super.key, required this.data, required this.onChange});

  final Map<String, DayHours> data;
  final void Function(String key, DayHours value) onChange;

  String _fmt(TimeOfDay t) =>
      "${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}";

  Future<void> _pick(BuildContext ctx, String key, bool isStart) async {
    final current = data[key]!;
    final initial = (isStart ? current.start : current.end) ?? const TimeOfDay(hour: 8, minute: 0);
    final t = await showTimePicker(context: ctx, initialTime: initial);
    if (t != null) {
      final next = current.copyWith(
        start: isStart ? t : current.start,
        end: isStart ? current.end : t,
      );
      onChange(key, next);
    }
  }

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    const order = ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'];
    const labels = {
      'mon': 'Mon',
      'tue': 'Tue',
      'wed': 'Wed',
      'thu': 'Thu',
      'fri': 'Fri',
      'sat': 'Sat',
      'sun': 'Sun',
    };

    for (final k in order) {
      final v = data[k]!;
      rows.add(
        DayRow(
          label: labels[k]!,
          enabled: v.enabled,
          startText: v.start == null ? '--:--' : _fmt(v.start!),
          endText: v.end == null ? '--:--' : _fmt(v.end!),
          onToggle: (e) => onChange(k, v.copyWith(enabled: e)),
          onTapStart: () => _pick(context, k, true),
          onTapEnd: () => _pick(context, k, false),
        ).animate().fadeIn(duration: 150.ms).slideX(begin: 0.03, end: 0),
      );
      rows.add(const SizedBox(height: 8));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Set hours per day', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 10),
        ...rows,
      ],
    );
  }
}
