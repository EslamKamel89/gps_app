import 'package:bloc/bloc.dart';
import 'package:gps_app/core/enums/response_type.dart';
import 'package:gps_app/core/helpers/print_helper.dart';
import 'package:gps_app/core/models/api_response_model.dart';
import 'package:gps_app/core/service_locator/service_locator.dart';
import 'package:gps_app/features/auth/controllers/auth_controller.dart';
import 'package:gps_app/features/auth/models/district_model.dart';
import 'package:gps_app/features/auth/models/state_model.dart';

part 'state_and_district_state.dart';

class StateAndDistrictCubit extends Cubit<StateAndDistrictState> {
  final AuthController controller = serviceLocator();
  StateAndDistrictCubit()
    : super(
        StateAndDistrictState(
          states: ApiResponseModel(),
          districts: ApiResponseModel(),
        ),
      );
  Future states() async {
    final t = prt('states - StateAndDistrictCubit');
    emit(
      state.copyWith(
        states: state.states.copyWith(
          errorMessage: null,
          response: ResponseEnum.loading,
          data: [],
        ),
      ),
    );
    final ApiResponseModel<List<StateModel>> response =
        await controller.states();
    pr(response, t);
    emit(state.copyWith(states: response));
  }

  Future selectState({required String stateName}) async {
    final t = prt('selectState - StateAndDistrictCubit');
    StateModel? stateModel = state.states.data?.firstWhere(
      (s) => s.name == stateName,
    );
    if (stateModel == null) return;
    emit(
      state.copyWith(
        state: stateModel,
        districts: ApiResponseModel(response: ResponseEnum.loading),
        district: null,
      ),
    );
    final ApiResponseModel<List<DistrictModel>> response = await controller
        .districts(stateId: stateModel.id!);
    pr(response, t);
    emit(state.copyWith(districts: response));
  }

  DistrictModel? selectDistrict({required String districtName}) {
    DistrictModel? district = state.districts.data?.firstWhere(
      (d) => d.name == districtName,
    );
    emit(state.copyWith(district: district));
    return district;
  }
}
