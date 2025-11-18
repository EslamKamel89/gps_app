import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_app/core/enums/response_type.dart';
import 'package:gps_app/core/helpers/print_helper.dart';
import 'package:gps_app/core/models/api_response_model.dart';
import 'package:gps_app/core/service_locator/service_locator.dart';
import 'package:gps_app/features/notifications/controller/notification_controller.dart';
import 'package:gps_app/features/notifications/models/notification_model.dart';

class NotificationCubit extends Cubit<ApiResponseModel<NotificationModel>> {
  NotificationCubit() : super(ApiResponseModel());
  final NotificationController controller = serviceLocator<NotificationController>();
  Future notifications() async {
    final t = prt('notifications - NotificationCubit');
    emit(state.copyWith(errorMessage: null, response: ResponseEnum.loading));
    final ApiResponseModel<NotificationModel> response = await controller.notifications();
    pr(response, t);
    emit(response);
  }
}
