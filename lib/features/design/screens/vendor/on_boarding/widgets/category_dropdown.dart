// features/vendor_onboarding/widgets/category_dropdown.dart

import 'package:flutter/material.dart';

class CategoryDropdown extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  static const List<String> categories = [
    'Appetizers',
    'Mains',
    'Desserts',
    'Beverages',
    'Sides',
    'Salads',
    'Specials',
    'Soups',
    'Vegan',
    'Gluten-Free',
  ];

  const CategoryDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: const InputDecoration(
        hintText: 'Select category',
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        isDense: false,
      ),
      items:
          categories.map((cat) {
            return DropdownMenuItem(
              value: cat,
              child: Text(cat, style: const TextStyle(fontSize: 14)),
            );
          }).toList(),
      onChanged: (val) => onChanged(val!),
      style: const TextStyle(fontSize: 14),
      dropdownColor: Colors.white,
      borderRadius: BorderRadius.circular(12),
    );
  }
}
