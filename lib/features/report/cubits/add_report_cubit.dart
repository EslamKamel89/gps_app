import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_app/core/enums/response_type.dart';
import 'package:gps_app/core/helpers/print_helper.dart';
import 'package:gps_app/core/models/api_response_model.dart';
import 'package:gps_app/core/service_locator/service_locator.dart';
import 'package:gps_app/features/report/controller/report_controller.dart';
import 'package:gps_app/features/report/models/report_param.dart';

class AddReportCubit extends Cubit<ApiResponseModel<bool>> {
  AddReportCubit() : super(ApiResponseModel());
  final ReportController controller = serviceLocator<ReportController>();
  Future add(ReportParam param) async {
    final t = prt('add - AddReportController');
    emit(state.copyWith(errorMessage: null, response: ResponseEnum.loading));
    final ApiResponseModel<bool> response = await controller.addReport(param);
    pr(response, t);
    emit(response);
  }
}
