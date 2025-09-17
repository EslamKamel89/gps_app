import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gps_app/features/auth/models/operating_time_model.dart';
import 'package:gps_app/features/auth/presentation/widgets/operating_hours_picker/operating_hours_sheet.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';

enum OperatingMode { alwaysOpen, allDaysSame, custom }

class DayHours {
  final bool enabled;
  final TimeOfDay? start;
  final TimeOfDay? end;
  DayHours({this.enabled = false, this.start, this.end});
  DayHours copyWith({bool? enabled, TimeOfDay? start, TimeOfDay? end}) =>
      DayHours(
        enabled: enabled ?? this.enabled,
        start: start ?? this.start,
        end: end ?? this.end,
      );
}

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
    bool is247(List<String>? r) =>
        r?.length == 2 && r![0] == '00:00' && r[1] == '23:59';
    final days = [v.mon, v.tue, v.wed, v.thu, v.fri, v.sat, v.sun];

    if (days.every(is247)) return 'Open 24/7';
    if (days.every(
      (d) =>
          d != null &&
          d.length == 2 &&
          d[0] == days.first![0] &&
          d[1] == days.first![1],
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
      builder: (_) => OperatingHoursSheet(initialValue: _current),
    );
    if (result != null) {
      setState(() => _current = result);
      widget.onChanged(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
          onTap: _openSheet,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: GPSColors.primary,
            ),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      widget.icon ?? Icons.calendar_month,
                      color: Colors.white,
                    ),
                    GPSGaps.w8,
                    Text(
                      widget.buttonText,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  _summary(),
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
        )
        .animate()
        .fadeIn(duration: 300.ms)
        .slideY(begin: 0.1, end: 0, curve: Curves.easeOut);
  }
}
