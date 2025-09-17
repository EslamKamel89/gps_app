import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/auth/models/operating_time_model.dart';

enum _OperatingMode { alwaysOpen, allDaysSame, custom }

class OperatingHoursPicker extends StatefulWidget {
  const OperatingHoursPicker({
    super.key,
    required this.onChanged,
    this.initialValue,
    this.buttonText = 'Pick Operating Time',
    this.icon,
  });

  final ValueChanged<OperatingTimeModel> onChanged;
  final OperatingTimeModel? initialValue;
  final String buttonText;
  final IconData? icon;

  @override
  State<OperatingHoursPicker> createState() => _OperatingHoursPickerState();
}

class _OperatingHoursPickerState extends State<OperatingHoursPicker> {
  OperatingTimeModel? _current;

  @override
  void initState() {
    super.initState();
    _current = widget.initialValue;
  }

  String _summary() {
    final v = _current;
    if (v == null) return 'Not set';
    bool is247(List<String>? r) => r?.length == 2 && r![0] == '00:00' && r[1] == '23:59';
    final days = [v.mon, v.tue, v.wed, v.thu, v.fri, v.sat, v.sun];

    if (days.every(is247)) return 'Open 24/7';
    if (days.every(
      (d) => d != null && d.length == 2 && d[0] == days.first![0] && d[1] == days.first![1],
    )) {
      return 'All days: ${days.first![0]} → ${days.first![1]}';
    }
    return 'Custom hours';
  }

  Future<void> _openSheet() async {
    final result = await showModalBottomSheet<OperatingTimeModel>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _OperatingHoursSheet(initialValue: _current),
    );
    if (result != null) {
      setState(() => _current = result);
      widget.onChanged(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: _openSheet,
      icon: Icon(widget.icon ?? Icons.schedule),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      label: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.buttonText, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 2),
          Text(_summary(), style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1, end: 0, curve: Curves.easeOut);
  }
}

class _OperatingHoursSheet extends StatefulWidget {
  const _OperatingHoursSheet({required this.initialValue});
  final OperatingTimeModel? initialValue;

  @override
  State<_OperatingHoursSheet> createState() => _OperatingHoursSheetState();
}

class _OperatingHoursSheetState extends State<_OperatingHoursSheet> {
  _OperatingMode _mode = _OperatingMode.allDaysSame;

  // all-days-same times
  TimeOfDay _allStart = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay _allEnd = const TimeOfDay(hour: 20, minute: 0);

  // custom per-day
  final Map<String, _DayHours> _custom = {
    'mon': _DayHours(),
    'tue': _DayHours(),
    'wed': _DayHours(),
    'thu': _DayHours(),
    'fri': _DayHours(),
    'sat': _DayHours(),
    'sun': _DayHours(),
  };

  @override
  void initState() {
    super.initState();
    final v = widget.initialValue;
    if (v != null) {
      final all = [v.mon, v.tue, v.wed, v.thu, v.fri, v.sat, v.sun];
      bool is247(List<String>? r) => r?.length == 2 && r![0] == '00:00' && r[1] == '23:59';
      if (all.every(is247)) {
        _mode = _OperatingMode.alwaysOpen;
      } else if (all.every(
        (d) => d != null && d.length == 2 && d[0] == all.first![0] && d[1] == all.first![1],
      )) {
        _mode = _OperatingMode.allDaysSame;
        final s = _parse(all.first![0]);
        final e = _parse(all.first![1]);
        if (s != null) _allStart = s;
        if (e != null) _allEnd = e;
      } else {
        _mode = _OperatingMode.custom;
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
      _custom[key] = _DayHours(enabled: true, start: s, end: e);
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

    if (_mode == _OperatingMode.alwaysOpen) {
      out = OperatingTimeModel(
        mon: ['00:00', '23:59'],
        tue: ['00:00', '23:59'],
        wed: ['00:00', '23:59'],
        thu: ['00:00', '23:59'],
        fri: ['00:00', '23:59'],
        sat: ['00:00', '23:59'],
        sun: ['00:00', '23:59'],
      );
    } else if (_mode == _OperatingMode.allDaysSame) {
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
      void setDay(String k, _DayHours v) {
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
              SegmentedButton<_OperatingMode>(
                segments: const [
                  ButtonSegment(
                    value: _OperatingMode.alwaysOpen,
                    icon: Icon(Icons.bolt),
                    label: Text('24/7'),
                  ),
                  ButtonSegment(
                    value: _OperatingMode.allDaysSame,
                    icon: Icon(Icons.calendar_today),
                    label: Text('All Days'),
                  ),
                  ButtonSegment(
                    value: _OperatingMode.custom,
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
                  _OperatingMode.alwaysOpen => _AlwaysOpenPreview(key: const ValueKey('aop')),
                  _OperatingMode.allDaysSame => _AllDaysSameEditor(
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
                  _OperatingMode.custom => _CustomDaysEditor(
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

class _AlwaysOpenPreview extends StatelessWidget {
  const _AlwaysOpenPreview({super.key});

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

class _AllDaysSameEditor extends StatelessWidget {
  const _AllDaysSameEditor({
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
            Expanded(child: _TimeBox(label: 'Start', value: _fmt(start), onTap: onPickStart)),
            const SizedBox(width: 10),
            Expanded(child: _TimeBox(label: 'End', value: _fmt(end), onTap: onPickEnd)),
          ],
        ),
      ],
    ).animate().fadeIn().slideY(begin: 0.1, end: 0);
  }
}

class _CustomDaysEditor extends StatelessWidget {
  const _CustomDaysEditor({super.key, required this.data, required this.onChange});

  final Map<String, _DayHours> data;
  final void Function(String key, _DayHours value) onChange;

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
        _DayRow(
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

class _DayRow extends StatelessWidget {
  const _DayRow({
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
          _TimeChip(
            label: 'Start',
            text: startText,
            onTap: enabled ? onTapStart : null,
            disabledColor: disabledColor,
          ),
          const SizedBox(width: 8),
          _TimeChip(
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

class _TimeBox extends StatelessWidget {
  const _TimeBox({required this.label, required this.value, required this.onTap});
  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: 4),
            Text(value, style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
      ),
    );
  }
}

class _TimeChip extends StatelessWidget {
  const _TimeChip({
    required this.label,
    required this.text,
    required this.onTap,
    required this.disabledColor,
  });
  final String label;
  final String text;
  final VoidCallback? onTap;
  final Color disabledColor;

  @override
  Widget build(BuildContext context) {
    final active = onTap != null;
    final border = active ? Theme.of(context).colorScheme.primary : disabledColor;
    return ActionChip(
      label: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelSmall),
          Text(text, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
      onPressed: onTap,
      shape: StadiumBorder(side: BorderSide(color: border)),
      avatar: const Icon(Icons.access_time),
    );
  }
}

class _DayHours {
  final bool enabled;
  final TimeOfDay? start;
  final TimeOfDay? end;
  _DayHours({this.enabled = false, this.start, this.end});
  _DayHours copyWith({bool? enabled, TimeOfDay? start, TimeOfDay? end}) =>
      _DayHours(enabled: enabled ?? this.enabled, start: start ?? this.start, end: end ?? this.end);
}
