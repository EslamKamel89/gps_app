import 'package:flutter/material.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';

class HomeFilters {
  String? distance;
  String? category;
  String? subcategory;
  final Set<String> diets;

  HomeFilters({this.distance, this.category, this.subcategory, Set<String>? diets})
    : diets = diets ?? <String>{};

  HomeFilters copyWith({
    String? distance,
    String? category,
    String? subcategory,
    Set<String>? diets,
  }) {
    return HomeFilters(
      distance: distance ?? this.distance,
      category: category ?? this.category,
      subcategory: subcategory ?? this.subcategory,
      diets: diets ?? Set<String>.from(this.diets),
    );
  }
}

class FilterDialog extends StatefulWidget {
  final HomeFilters initial;

  const FilterDialog({super.key, required this.initial});

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  static const _distances = <String>['Any', '1 km', '3 km', '5 km', '10 km', '20 km'];

  static const Map<String, List<String>> _categories = {
    'Burgers': ['Beef Burger', 'Chicken Burger', 'Veggie Burger'],
    'Pizza': ['Margherita', 'Pepperoni', 'Veggie', 'BBQ Chicken'],
    'Sushi': ['Maki', 'Nigiri', 'Sashimi', 'Uramaki'],
    'Dessert': ['Ice Cream', 'Cheesecake', 'Brownie'],
  };

  static const _diets = <String>{
    'Halal',
    'Vegan',
    'Vegetarian',
    'Keto',
    'Gluten-free',
    'Dairy-free',
  };

  late String? _distance;
  late String? _category;
  late String? _subcategory;
  late Set<String> _dietsSel;

  @override
  void initState() {
    super.initState();
    _distance = widget.initial.distance ?? 'Any';
    _category = widget.initial.category;
    _subcategory = widget.initial.subcategory;
    _dietsSel = Set<String>.from(widget.initial.diets);
  }

  @override
  Widget build(BuildContext context) {
    final subcats = _category != null ? _categories[_category] ?? [] : <String>[];

    return AlertDialog(
      backgroundColor: GPSColors.background.withOpacity(0.9),
      title: const Text('Filters'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: _distance,
              decoration: const InputDecoration(labelText: 'Distance'),
              items: _distances.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
              onChanged: (v) => setState(() => _distance = v),
            ),
            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              value: _category,
              decoration: const InputDecoration(labelText: 'Category'),
              items:
                  _categories.keys.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (v) {
                setState(() {
                  _category = v;
                  _subcategory = null;
                });
              },
            ),
            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              value: _subcategory,
              decoration: const InputDecoration(labelText: 'Subcategory'),
              items: subcats.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
              onChanged: (_category == null) ? null : (v) => setState(() => _subcategory = v),
            ),
            const SizedBox(height: 16),

            Align(
              alignment: Alignment.centerLeft,
              child: Text('Diets', style: Theme.of(context).textTheme.titleMedium),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  _diets.map((d) {
                    final isSelected = _dietsSel.contains(d);
                    return FilterChip(
                      label: Text(d),
                      selected: isSelected,
                      onSelected: (val) {
                        setState(() {
                          if (val) {
                            _dietsSel.add(d);
                          } else {
                            _dietsSel.remove(d);
                          }
                        });
                      },
                    );
                  }).toList(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop<HomeFilters>(context, null),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            final result = HomeFilters(
              distance: _distance == 'Any' ? null : _distance,
              category: _category,
              subcategory: _subcategory,
              diets: _dietsSel,
            );
            Navigator.pop<HomeFilters>(context, result);
          },
          child: const Text('apply'),
        ),
      ],
    );
  }
}
