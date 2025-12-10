import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_app/core/enums/response_type.dart';
import 'package:gps_app/core/helpers/print_helper.dart';
import 'package:gps_app/core/models/api_response_model.dart';
import 'package:gps_app/core/service_locator/service_locator.dart';
import 'package:gps_app/features/report/controller/report_controller.dart';
import 'package:gps_app/features/report/models/user_blocked_model.dart';

class BlockedUsersCubit extends Cubit<ApiResponseModel<List<UserBlockedModel>>> {
  BlockedUsersCubit() : super(ApiResponseModel());
  final ReportController controller = serviceLocator<ReportController>();
  Future getBlockedUsers() async {
    final t = prt('getBlockedUsers - BlockedUsersCubit');
    emit(state.copyWith(errorMessage: null, response: ResponseEnum.loading));
    final ApiResponseModel<List<UserBlockedModel>> response = await controller.blockedUsers();
    pr(response, t);
    emit(response);
  }

  bool isBlocked(int? userId) {
    if (userId == null || state.data == null || state.data?.isEmpty == true) return false;
    return state.data?.where((blocked) => blocked.blockedUserId == userId).isNotEmpty == true;
  }
}
