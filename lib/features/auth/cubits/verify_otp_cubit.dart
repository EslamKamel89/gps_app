import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_app/core/enums/response_type.dart';
import 'package:gps_app/core/helpers/print_helper.dart';
import 'package:gps_app/core/models/api_response_model.dart';
import 'package:gps_app/core/service_locator/service_locator.dart';
import 'package:gps_app/features/auth/controllers/auth_controller.dart';

class VerifyOtpCubit extends Cubit<ApiResponseModel<bool>> {
  VerifyOtpCubit() : super(ApiResponseModel());
  final AuthController controller = serviceLocator<AuthController>();
  Future verifyOtp({required String code}) async {
    final t = prt('verifyOtp - VerifyOtpCubit');
    emit(state.copyWith(errorMessage: null, response: ResponseEnum.loading));
    final ApiResponseModel<bool> response = await controller.verifyOtp(code: code);
    pr(response, t);
    emit(response);
  }

  Future<ApiResponseModel<bool>> requestOtp() async {
    final t = prt('requestOtp - VerifyOtpCubit');
    final response = await controller.requestOtp();
    pr(response, t);
    return response;
  }
}
