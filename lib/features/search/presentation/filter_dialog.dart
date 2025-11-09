import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/search/cubits/search_cubit/search_cubit.dart';
import 'package:gps_app/features/user/preferences/presentation/widgets/category_selector.dart';

class FilterDialog extends StatefulWidget {
  // final HomeFilters initial;

  const FilterDialog({super.key});

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  late final SearchCubit cubit;
  final List<int?> _distances = [null, 3, 5, 10, 20, 40, 80];
  @override
  void initState() {
    cubit = context.read<SearchCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final content = SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<int?>(
            initialValue: cubit.state.distance,
            decoration: const InputDecoration(hintText: 'Please Select Distance'),
            items:
                _distances
                    .map(
                      (d) =>
                          DropdownMenuItem(value: d, child: Text(d == null ? 'Any' : '$d miles')),
                    )
                    .toList(),
            onChanged: (v) => setState(() => cubit.state.distance = v),
          ),
          const SizedBox(height: 12),

          CategorySelectorProvider(
            onSelect: (c) {
              cubit.state.category = c.selectedCategory;
              cubit.state.subCategory = c.selectedSubCategory;
            },
          ),
          const SizedBox(height: 16),

          Align(
            alignment: Alignment.centerLeft,
            child: Text('Diets', style: Theme.of(context).textTheme.titleMedium),
          ),
          const SizedBox(height: 8),

          // Wrap(
          //   spacing: 8,
          //   runSpacing: 8,
          //   children:
          //       _diets.map((d) {
          //         final isSelected = _dietsSel.contains(d);
          //         return FilterChip(
          //           label: Text(d),
          //           selected: isSelected,
          //           onSelected: (val) {
          //             setState(() {
          //               if (val) {
          //                 _dietsSel.add(d);
          //               } else {
          //                 _dietsSel.remove(d);
          //               }
          //             });
          //           },
          //         );
          //       }).toList(),
          // ),
        ],
      ),
    );
    final actions = [
      TextButton(
        // onPressed: () => Navigator.pop<HomeFilters>(context, null),
        onPressed: () {},
        child: const Text('Cancel'),
      ),
      FilledButton(
        onPressed: () {
          // final result = HomeFilters(
          //   distance: _distance == 'Any' ? null : _distance,
          //   category: _category,
          //   subcategory: _subcategory,
          //   diets: _dietsSel,
          // );
          // Navigator.pop<HomeFilters>(context, result);
        },
        child: const Text('apply'),
      ),
    ];

    return Container(
      color: GPSColors.primary.withOpacity(0.4),
      padding: EdgeInsets.all(20),
      child: Column(children: [content, GPSGaps.h20, Row(children: actions)]),
    );
  }
}
