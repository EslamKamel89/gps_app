import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_app/core/enums/response_type.dart';
import 'package:gps_app/core/helpers/print_helper.dart';
import 'package:gps_app/core/models/api_response_model.dart';
import 'package:gps_app/core/service_locator/service_locator.dart';
import 'package:gps_app/features/auth/controllers/auth_controller.dart';
import 'package:gps_app/features/auth/models/user_model.dart';

class UserCubit extends Cubit<ApiResponseModel<UserModel>> {
  UserCubit() : super(ApiResponseModel());
  final AuthController controller = serviceLocator<AuthController>();
  Future user() async {
    final t = prt('user - UserCubit');
    emit(state.copyWith(errorMessage: null, response: ResponseEnum.loading));
    final ApiResponseModel<UserModel> response = await controller.userSync();
    pr(response, t);
    emit(response);
  }

  void update(final UserModel newState) async {
    emit(state.copyWith(data: newState));
  }
}
