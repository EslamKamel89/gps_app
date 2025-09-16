import 'package:bloc/bloc.dart';
import 'package:gps_app/core/models/api_response_model.dart';
import 'package:gps_app/features/auth/models/district_model.dart';
import 'package:gps_app/features/auth/models/state_model.dart';

part 'state_and_district_state.dart';

class StateAndDistrictCubit extends Cubit<StateAndDistrictState> {
  StateAndDistrictCubit()
    : super(StateAndDistrictState(states: ApiResponseModel(), districts: ApiResponseModel()));
}
