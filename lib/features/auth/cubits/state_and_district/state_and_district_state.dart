// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'state_and_district_cubit.dart';

class StateAndDistrictState {
  final ApiResponseModel<List<StateModel>> states;
  final ApiResponseModel<List<DistrictModel>> districts;
  final StateModel? state;
  final DistrictModel? district;
  StateAndDistrictState({
    required this.states,
    required this.districts,
    this.state,
    this.district,
  });

  StateAndDistrictState copyWith({
    ApiResponseModel<List<StateModel>>? states,
    ApiResponseModel<List<DistrictModel>>? districts,
    StateModel? state,
    DistrictModel? district,
  }) {
    return StateAndDistrictState(
      states: states ?? this.states,
      districts: districts ?? this.districts,
      state: state ?? this.state,
      district: district ?? this.district,
    );
  }

  @override
  String toString() {
    return 'StateAndDistrictState(states: $states, districts: $districts, state: $state, district: $district)';
  }
}
