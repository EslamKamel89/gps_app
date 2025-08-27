// features/vendor_onboarding/widgets/opening_hours_editor.dart

import 'package:flutter/material.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';

class OpeningHoursEditor extends StatefulWidget {
  final Map<String, String> hours;
  final ValueChanged<Map<String, String>> onChanged;

  const OpeningHoursEditor({super.key, required this.hours, required this.onChanged});

  @override
  State<OpeningHoursEditor> createState() => _OpeningHoursEditorState();
}

class _OpeningHoursEditorState extends State<OpeningHoursEditor> {
  late Map<String, String> _hours;

  @override
  void initState() {
    _hours = Map.from(widget.hours);
    super.initState();
  }

  void _updateHours(String key, String value) {
    setState(() {
      _hours[key] = value;
      widget.onChanged(_hours);
    });
  }

  void _addCustom() {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text("Add Custom Schedule"),
            backgroundColor: GPSColors.background,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: "Days (e.g., Holidays)"),
                  onChanged: (v) => {},
                ),
                const SizedBox(height: 12),
                TextField(
                  decoration: const InputDecoration(labelText: "Hours (e.g., 10:00 AM - 8:00 PM)"),
                  onChanged: (v) => {},
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Add")),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Opening Hours',
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600, color: GPSColors.text),
        ),
        GPSGaps.h8,
        ..._hours.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    entry.key,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: SizedBox(
                    height: 40,
                    child: TextField(
                      // initialValue: entry.value,
                      onChanged: (v) => _updateHours(entry.key, v),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        isDense: true,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
        TextButton.icon(
          style: TextButton.styleFrom(foregroundColor: GPSColors.primary),
          icon: const Icon(Icons.add, size: 16),
          label: const Text('Add Custom Hours'),
          onPressed: _addCustom,
        ),
      ],
    );
  }
}
