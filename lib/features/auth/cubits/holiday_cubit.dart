import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_app/core/enums/response_type.dart';
import 'package:gps_app/core/helpers/print_helper.dart';
import 'package:gps_app/core/models/api_response_model.dart';
import 'package:gps_app/core/service_locator/service_locator.dart';
import 'package:gps_app/features/auth/controllers/auth_controller.dart';
import 'package:gps_app/features/auth/models/holiday_model.dart';

class HolidayCubit extends Cubit<ApiResponseModel<List<HolidayModel>>> {
  HolidayCubit() : super(ApiResponseModel());
  final AuthController controller = serviceLocator<AuthController>();
  Future holidaysIndex() async {
    final t = prt('holidaysIndex - HolidayCubit');
    emit(state.copyWith(errorMessage: null, response: ResponseEnum.loading));
    final ApiResponseModel<List<HolidayModel>> response =
        await controller.holidays();
    pr(response, t);
    emit(response);
  }
}
