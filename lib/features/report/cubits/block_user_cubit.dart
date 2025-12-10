import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_app/core/enums/response_type.dart';
import 'package:gps_app/core/helpers/print_helper.dart';
import 'package:gps_app/core/models/api_response_model.dart';
import 'package:gps_app/core/service_locator/service_locator.dart';
import 'package:gps_app/features/report/controller/report_controller.dart';

class BlockUserCubit extends Cubit<ApiResponseModel<bool>> {
  BlockUserCubit() : super(ApiResponseModel());
  final ReportController controller = serviceLocator<ReportController>();
  Future blockUser(int blockUserId, String reason) async {
    final t = prt('blockUser - BlockUserCubit');
    emit(state.copyWith(errorMessage: null, response: ResponseEnum.loading));
    final ApiResponseModel<bool> response = await controller.blockUser(
      blockUserId,
      reason,
    );
    pr(response, t);
    emit(response);
  }
}
