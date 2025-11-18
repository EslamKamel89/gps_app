import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/notifications/cubits/notification_cubit.dart'; // Adjust import path as needed

class NotificationFilterToggle extends StatefulWidget {
  const NotificationFilterToggle({super.key});

  @override
  State<NotificationFilterToggle> createState() => _NotificationFilterToggleState();
}

class _NotificationFilterToggleState extends State<NotificationFilterToggle> {
  static const List<String> _filters = ['All', 'Unread', 'Read'];

  late List<bool> _isSelected;
  late NotificationCubit cubit;
  @override
  void initState() {
    super.initState();
    _isSelected = List.generate(_filters.length, (index) => index == 0);
    cubit = context.read<NotificationCubit>();
  }

  void _toggle(int index) {
    setState(() {
      for (int i = 0; i < _isSelected.length; i++) {
        _isSelected[i] = false;
      }
      _isSelected[index] = true;
    });
    cubit.filterByRead(_filters[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.all(6),
      child: ToggleButtons(
        isSelected: _isSelected,
        onPressed: _toggle,
        borderRadius: BorderRadius.circular(10),
        constraints: const BoxConstraints(minHeight: 40, minWidth: 92),
        borderColor: GPSColors.cardBorder,
        selectedBorderColor: GPSColors.primary,
        fillColor: GPSColors.primary.withOpacity(0.1),
        color: GPSColors.mutedText,
        selectedColor: GPSColors.text,
        borderWidth: 1.5,
        children: [
          for (final label in _filters)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
            ),
        ],
      ),
    );
  }
}
