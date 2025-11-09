import 'package:flutter/material.dart';
import 'package:gps_app/core/helpers/print_helper.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';

class TypeMultiSelect extends StatefulWidget {
  const TypeMultiSelect({
    super.key,
    required this.onSelectionChanged,
    this.initialValue = const [],
  });

  final ValueChanged<List<String>> onSelectionChanged;

  final List<String> initialValue;

  @override
  State<TypeMultiSelect> createState() => _TypeMultiSelectState();
}

class _TypeMultiSelectState extends State<TypeMultiSelect> {
  static const List<String> _types = ['restaurant', 'farm', 'store'];

  late List<bool> _isSelected;

  List<String> get _selectedTypes => [
    for (int i = 0; i < _types.length; i++)
      if (_isSelected[i]) _types[i],
  ];

  @override
  void initState() {
    super.initState();

    // Initialize selection state based on initialValue
    _isSelected =
        _types.map((type) {
          return widget.initialValue.contains(type);
        }).toList();
  }

  void _toggle(int index) {
    setState(() {
      _isSelected[index] = !_isSelected[index];
    });
    widget.onSelectionChanged(_selectedTypes);
  }

  @override
  Widget build(BuildContext context) {
    pr(_selectedTypes, 'selected types');
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        // border: Border.all(color: GPSColors.cardBorder),
      ),
      padding: const EdgeInsets.all(6),
      child: ToggleButtons(
        isSelected: _isSelected,
        onPressed: _toggle,
        borderRadius: BorderRadius.circular(10),
        constraints: const BoxConstraints(minHeight: 40, minWidth: 92),
        borderColor: GPSColors.primary,
        selectedBorderColor: GPSColors.primary,
        fillColor: GPSColors.accent,
        color: Colors.black,
        selectedColor: Colors.white,
        children: [
          for (final label in _types)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
            ),
        ],
      ),
    );
  }
}
