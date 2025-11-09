import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';
import 'package:gps_app/features/search/cubits/search_cubit/search_cubit.dart';

class FiltersRow extends StatefulWidget {
  const FiltersRow({super.key});

  @override
  State<FiltersRow> createState() => _FiltersRowState();
}

class _FiltersRowState extends State<FiltersRow> {
  late final SearchCubit cubit;
  @override
  void initState() {
    cubit = context.read<SearchCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = cubit.state;
    final hasFilters =
        state.distance != null ||
        state.category != null ||
        state.subCategory != null ||
        state.diet != null;

    if (!hasFilters) return const SizedBox();
    return Column(
      children: [
        GPSGaps.h16,
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            if (state.distance != null)
              InputChip(
                label: Text('Distance: ${state.distance}'),
                onDeleted:
                    () => setState(() {
                      state.distance = null;
                    }),
              ),
            if (state.subCategory != null)
              InputChip(
                label: Text('Category: ${state.subCategory?.name}'),
                onDeleted:
                    () => setState(() {
                      state.subCategory = null;
                    }),
              ),
            if (state.diet != null)
              InputChip(
                label: Text(state.diet?.name ?? ''),
                onDeleted:
                    () => setState(() {
                      state.diet = null;
                    }),
              ),
          ],
        ),
      ],
    );
  }
}
