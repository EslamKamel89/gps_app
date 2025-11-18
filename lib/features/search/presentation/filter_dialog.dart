import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_app/features/auth/presentation/widgets/state_district_selector.dart';
import 'package:gps_app/features/design/utils/gps_colors.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/search/cubits/search_cubit/search_cubit.dart';
import 'package:gps_app/features/search/presentation/diets_row.dart';
import 'package:gps_app/features/search/presentation/type_multi_select.dart';
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
    final content = SizedBox(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Filter by Distance',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          DropdownButtonFormField<int?>(
            // initialValue: cubit.state.distance,
            decoration: const InputDecoration(
              hintText: 'Please Select Distance',
            ),
            items:
                _distances
                    .map(
                      (d) => DropdownMenuItem(
                        value: d,
                        child: Text(d == null ? 'Any' : '$d ml'),
                      ),
                    )
                    .toList(),
            onChanged: (v) => setState(() => cubit.state.distance = v),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Filter by Category',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          CategorySelectorProvider(
            onSelect: (c) {
              cubit.state.category = c.selectedCategory;
              cubit.state.subCategory = c.selectedSubCategory;
            },
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Filter by State and city',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          StateDistrictProvider(
            onSelect: (SelectedStateAndDistrict s) {
              cubit.state.state = s.selectedState;
              cubit.state.district = s.selectedDistrict;
            },
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Filter by Diets',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          DietsRowProvider(),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Pick what your looking for',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          TypeMultiSelect(
            onSelectionChanged: (types) {
              cubit.state.types = types;
            },
            initialValue: cubit.state.types ?? [],
          ),
        ],
      ),
    );
    final actions = [
      TextButton(
        onPressed: () {
          cubit.state.category = null;
          cubit.state.subCategory = null;
          cubit.state.diet = null;
          cubit.state.distance = null;
          Navigator.pop(context);
        },
        child: const Text('Cancel'),
      ),
      InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: BoxDecoration(
            color: GPSColors.accent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Text('Apply', style: TextStyle(color: Colors.white)),
        ),
      ),
    ];

    return Container(
      color: GPSColors.primary.withOpacity(0.4),
      padding: EdgeInsets.all(20),
      child: Column(children: [content, GPSGaps.h20, Row(children: actions)]),
    );
  }
}
