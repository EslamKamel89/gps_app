// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_app/core/widgets/inputs.dart';
import 'package:gps_app/features/auth/cubits/state_and_district/state_and_district_cubit.dart';
import 'package:gps_app/features/auth/models/district_model.dart';
import 'package:gps_app/features/auth/models/state_model.dart';
import 'package:gps_app/features/design/utils/gps_gaps.dart';

class SelectedStateAndDistrict {
  StateModel? selectedState;
  DistrictModel? selectedDistrict;
  SelectedStateAndDistrict({this.selectedState, this.selectedDistrict});

  SelectedStateAndDistrict copyWith({StateModel? selectedState, DistrictModel? selectedDistrict}) {
    return SelectedStateAndDistrict(
      selectedState: selectedState ?? this.selectedState,
      selectedDistrict: selectedDistrict ?? this.selectedDistrict,
    );
  }

  @override
  String toString() =>
      'SelectedStateAndDistrict(selectedState: $selectedState, selectedDistrict: $selectedDistrict)';
}

class StateDistrictProvider extends StatelessWidget {
  const StateDistrictProvider({super.key, required this.onSelect});
  final Function(SelectedStateAndDistrict) onSelect;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StateAndDistrictCubit()..states(),
      child: StateAndDistrictSelector(onSelect),
    );
  }
}

class StateAndDistrictSelector extends StatefulWidget {
  const StateAndDistrictSelector(this.onSelect, {super.key});
  final Function(SelectedStateAndDistrict) onSelect;

  @override
  State<StateAndDistrictSelector> createState() => _StateAndDistrictSelectorState();
}

class _StateAndDistrictSelectorState extends State<StateAndDistrictSelector> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StateAndDistrictCubit, StateAndDistrictState>(
      builder: (context, state) {
        final cubit = context.read<StateAndDistrictCubit>();
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (state.districts.data?.isNotEmpty == true)
              SearchableDropdownWidget(
                key: Key('district'),
                label: 'District',
                hintText: 'Select District',
                isRequired: true,
                options:
                    state.districts.data?.map((district) => district.name ?? '').toList() ?? [],
                handleSelectOption: (String option) {
                  final district = cubit.selectDistrict(districtName: option);
                  widget.onSelect(
                    SelectedStateAndDistrict(
                      selectedState: state.state,
                      selectedDistrict: district,
                    ),
                  );
                },
              ),
            if (state.districts.data?.isNotEmpty == true) GPSGaps.h8,
            SearchableDropdownWidget(
              key: Key('state'),
              label: 'State',
              hintText: 'Select State',
              isRequired: true,
              options: state.states.data?.map((stateModel) => stateModel.name ?? '').toList() ?? [],
              handleSelectOption: (String option) async {
                await cubit.selectState(stateName: option);
              },
            ),
          ],
        );
      },
    );
  }
}
