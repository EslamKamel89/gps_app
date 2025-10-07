import 'package:bloc/bloc.dart';
import 'package:gps_app/core/enums/response_type.dart';
import 'package:gps_app/core/helpers/print_helper.dart';
import 'package:gps_app/core/models/api_response_model.dart';
import 'package:gps_app/core/service_locator/service_locator.dart';
import 'package:gps_app/features/auth/controllers/auth_controller.dart';
import 'package:gps_app/features/auth/models/branch_model.dart';
import 'package:gps_app/features/auth/models/branch_param.dart';

part 'create_restaurant_branches_state.dart';

class CreateRestaurantBranchesCubit
    extends Cubit<CreateRestaurantBranchesState> {
  final controller = serviceLocator<AuthController>();
  CreateRestaurantBranchesCubit()
    : super(CreateRestaurantBranchesState.initial());
  void addBranch({required BranchParam branchParam}) {
    state.branches.add(branchParam);
    emit(state.copyWith());
  }

  void removeBranch({required BranchParam branchParam}) {
    state.branches.remove(branchParam);
    emit(state.copyWith());
  }

  Future createBranches() async {
    final t = prt('createBranches - CreateRestaurantBranchesCubit');

    pr(state.branches, 'state.sections');
    // return;
    emit(
      state.copyWith(
        branchesResponse: state.branchesResponse.copyWith(
          errorMessage: null,
          response: ResponseEnum.loading,
          data: [],
        ),
      ),
    );
    final ApiResponseModel<List<BranchModel>> response = await controller
        .createBranches(param: state.branches);
    pr(response, t);
    emit(state.copyWith(branchesResponse: response));
  }
}
