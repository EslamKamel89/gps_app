import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/auth/models/operating_time_model.dart';
import 'package:gps_app/features/auth/presentation/widgets/operating_hours_picker/all_days_same_editor.dart';
import 'package:gps_app/features/auth/presentation/widgets/operating_hours_picker/always_open_preview.dart';
import 'package:gps_app/features/auth/presentation/widgets/operating_hours_picker/custom_days_editor.dart';
import 'package:gps_app/features/auth/presentation/widgets/operating_hours_picker/operating_hour_picker.dart';

class OperatingHoursSheet extends StatefulWidget {
  const OperatingHoursSheet({super.key, required this.initialValue});
  final OperatingTimeModel? initialValue;

  @override
  State<OperatingHoursSheet> createState() => _OperatingHoursSheetState();
}

class _OperatingHoursSheetState extends State<OperatingHoursSheet> {
  OperatingMode _mode = OperatingMode.allDaysSame;

  // all-days-same times
  TimeOfDay _allStart = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay _allEnd = const TimeOfDay(hour: 20, minute: 0);

  // custom per-day
  final Map<String, DayHours> _custom = {
    'mon': DayHours(),
    'tue': DayHours(),
    'wed': DayHours(),
    'thu': DayHours(),
    'fri': DayHours(),
    'sat': DayHours(),
    'sun': DayHours(),
  };

  @override
  void initState() {
    super.initState();
    final v = widget.initialValue;
    if (v != null) {
      final all = [v.mon, v.tue, v.wed, v.thu, v.fri, v.sat, v.sun];
      bool is247(List<String>? r) => r?.length == 2 && r![0] == '00:00' && r[1] == '23:59';
      if (all.every(is247)) {
        _mode = OperatingMode.alwaysOpen;
      } else if (all.every(
        (d) => d != null && d.length == 2 && d[0] == all.first![0] && d[1] == all.first![1],
      )) {
        _mode = OperatingMode.allDaysSame;
        final s = _parse(all.first![0]);
        final e = _parse(all.first![1]);
        if (s != null) _allStart = s;
        if (e != null) _allEnd = e;
      } else {
        _mode = OperatingMode.custom;
        _seedCustom('mon', v.mon);
        _seedCustom('tue', v.tue);
        _seedCustom('wed', v.wed);
        _seedCustom('thu', v.thu);
        _seedCustom('fri', v.fri);
        _seedCustom('sat', v.sat);
        _seedCustom('sun', v.sun);
      }
    }
  }

  void _seedCustom(String key, List<String>? pair) {
    if (pair == null || pair.length != 2) return;
    final s = _parse(pair[0]);
    final e = _parse(pair[1]);
    if (s != null && e != null) {
      _custom[key] = DayHours(enabled: true, start: s, end: e);
    }
  }

  TimeOfDay? _parse(String hhmm) {
    final parts = hhmm.split(':');
    if (parts.length != 2) return null;
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    if (h == null || m == null) return null;
    return TimeOfDay(hour: h, minute: m);
  }

  String _fmt(TimeOfDay t) =>
      "${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}";

  Future<TimeOfDay?> _pick(TimeOfDay initial) async {
    return await showTimePicker(context: context, initialTime: initial);
  }

  void _apply() {
    late final OperatingTimeModel out;

    if (_mode == OperatingMode.alwaysOpen) {
      out = OperatingTimeModel(
        mon: ['00:00', '23:59'],
        tue: ['00:00', '23:59'],
        wed: ['00:00', '23:59'],
        thu: ['00:00', '23:59'],
        fri: ['00:00', '23:59'],
        sat: ['00:00', '23:59'],
        sun: ['00:00', '23:59'],
      );
    } else if (_mode == OperatingMode.allDaysSame) {
      if (!_valid(_allStart, _allEnd)) {
        _toast('End time must be after start time');
        return;
      }
      final s = _fmt(_allStart), e = _fmt(_allEnd);
      out = OperatingTimeModel(
        mon: [s, e],
        tue: [s, e],
        wed: [s, e],
        thu: [s, e],
        fri: [s, e],
        sat: [s, e],
        sun: [s, e],
      );
    } else {
      final m = OperatingTimeModel();
      void setDay(String k, DayHours v) {
        if (v.enabled && v.start != null && v.end != null) {
          if (!_valid(v.start!, v.end!)) {
            _toast('On ${_dayLabel(k)}, end must be after start');
            throw 'invalid'; // stop apply
          }
          final pair = [_fmt(v.start!), _fmt(v.end!)];
          switch (k) {
            case 'mon':
              m.mon = pair;
              break;
            case 'tue':
              m.tue = pair;
              break;
            case 'wed':
              m.wed = pair;
              break;
            case 'thu':
              m.thu = pair;
              break;
            case 'fri':
              m.fri = pair;
              break;
            case 'sat':
              m.sat = pair;
              break;
            case 'sun':
              m.sun = pair;
              break;
          }
        }
      }

      try {
        _custom.forEach(setDay);
      } catch (_) {
        return;
      }
      out = m;
    }

    Navigator.of(context).pop(out);
  }

  bool _valid(TimeOfDay s, TimeOfDay e) {
    final si = s.hour * 60 + s.minute;
    final ei = e.hour * 60 + e.minute;
    return ei > si;
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating));
  }

  String _dayLabel(String k) {
    switch (k) {
      case 'mon':
        return 'Mon';
      case 'tue':
        return 'Tue';
      case 'wed':
        return 'Wed';
      case 'thu':
        return 'Thu';
      case 'fri':
        return 'Fri';
      case 'sat':
        return 'Sat';
      case 'sun':
        return 'Sun';
      default:
        return k;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 12,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 5,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: cs.outlineVariant,
                  borderRadius: BorderRadius.circular(100),
                ),
              ).animate().fadeIn().slideY(begin: -0.2, end: 0),
              Text('Operating Hours', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              SegmentedButton<OperatingMode>(
                segments: const [
                  ButtonSegment(
                    value: OperatingMode.alwaysOpen,
                    icon: Icon(Icons.bolt),
                    label: Text('24/7'),
                  ),
                  ButtonSegment(
                    value: OperatingMode.allDaysSame,
                    icon: Icon(Icons.calendar_today),
                    label: Text('All Days'),
                  ),
                  ButtonSegment(
                    value: OperatingMode.custom,
                    icon: Icon(Icons.tune),
                    label: Text('Custom'),
                  ),
                ],
                selected: {_mode},
                onSelectionChanged: (s) => setState(() => _mode = s.first),
                style: ButtonStyle(
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ).animate().fadeIn(duration: 250.ms),

              const SizedBox(height: 16),

              AnimatedSwitcher(
                duration: 250.ms,
                child: switch (_mode) {
                  OperatingMode.alwaysOpen => AlwaysOpenPreview(key: const ValueKey('aop')),
                  OperatingMode.allDaysSame => AllDaysSameEditor(
                    key: const ValueKey('ads'),
                    start: _allStart,
                    end: _allEnd,
                    onPickStart: () async {
                      final t = await _pick(_allStart);
                      if (t != null) setState(() => _allStart = t);
                    },
                    onPickEnd: () async {
                      final t = await _pick(_allEnd);
                      if (t != null) setState(() => _allEnd = t);
                    },
                  ),
                  OperatingMode.custom => CustomDaysEditor(
                    key: const ValueKey('cst'),
                    data: _custom,
                    onChange: (k, v) => setState(() => _custom[k] = v),
                  ),
                },
              ),

              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _apply,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Apply'),
                    ),
                  ),
                ],
              ).animate().fadeIn().slideY(begin: 0.1, end: 0),
            ],
          ),
        ),
      ),
    );
  }
}
