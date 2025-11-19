import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_app/core/enums/response_type.dart';
import 'package:gps_app/core/helpers/print_helper.dart';
import 'package:gps_app/core/models/api_response_model.dart';
import 'package:gps_app/core/service_locator/service_locator.dart';
import 'package:gps_app/features/notifications/controller/notification_controller.dart';
import 'package:gps_app/features/notifications/models/notification_model.dart';

class NotificationCubit extends Cubit<ApiResponseModel<List<NotificationModel>>> {
  NotificationCubit() : super(ApiResponseModel());
  final NotificationController controller = serviceLocator<NotificationController>();
  List<NotificationModel> filtered = [];
  Future notifications() async {
    final t = prt('notifications - NotificationCubit');
    emit(state.copyWith(errorMessage: null, response: ResponseEnum.loading));
    final ApiResponseModel<List<NotificationModel>> response = await controller.notifications();
    filtered = response.data ?? [];
    pr(response, t);
    emit(response);
  }

  void filterByRead(String filterState) {
    if (filterState != 'All') {
      final isRead = filterState == 'Read' ? 1 : 0;
      filtered = state.data?.where((n) => n.isRead == isRead).toList() ?? [];
    } else {
      filtered = state.data ?? [];
    }
    emit(state.copyWith());
  }

  int getUnreadCount() {
    return state.data?.where((n) => n.isRead == 0).length ?? 0;
  }

  Future<void> markAsRead(NotificationModel notification) async {
    notification.isRead = 1;
    emit(state.copyWith());
    controller.markAsRead(notification.id);
  }
}
