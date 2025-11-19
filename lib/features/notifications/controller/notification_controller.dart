import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:gps_app/core/api_service/api_consumer.dart';
import 'package:gps_app/core/api_service/end_points.dart';
import 'package:gps_app/core/enums/response_type.dart';
import 'package:gps_app/core/helpers/print_helper.dart';
import 'package:gps_app/core/helpers/snackbar.dart';
import 'package:gps_app/core/models/api_response_model.dart';
import 'package:gps_app/core/service_locator/service_locator.dart';
import 'package:gps_app/features/notifications/models/notification_model.dart';

class NotificationController {
  final _api = serviceLocator<ApiConsumer>();
  Future<ApiResponseModel<List<NotificationModel>>> notifications() async {
    final t = prt('notifications - NotificationController');
    try {
      final response = await _api.get("${EndPoint.notifications}?want=all");
      pr(response, '$t - response');
      final List<NotificationModel> models =
          (response['notifications'] as List)
              .map((json) => NotificationModel.fromJson(json))
              .toList();
      return pr(ApiResponseModel(response: ResponseEnum.success, data: models), t);
    } catch (e) {
      String errorMessage = e.toString();
      if (e is DioException) {
        errorMessage = jsonEncode(e.response?.data ?? 'Unknown error occurred');
      }
      showSnackbar('Error', errorMessage, true);
      return pr(ApiResponseModel(errorMessage: errorMessage, response: ResponseEnum.failed), t);
    }
  }

  Future<ApiResponseModel<bool>> markAsRead(int? notificationId) async {
    final t = prt('markAsRead - NotificationController');
    try {
      final response = await _api.put("${EndPoint.notifications}/$notificationId");
      pr(response, '$t - response');
      return pr(ApiResponseModel(response: ResponseEnum.success, data: true), t);
    } catch (e) {
      String errorMessage = e.toString();
      if (e is DioException) {
        errorMessage = jsonEncode(e.response?.data ?? 'Unknown error occurred');
      }
      showSnackbar('Error', errorMessage, true);
      return pr(ApiResponseModel(errorMessage: errorMessage, response: ResponseEnum.failed), t);
    }
  }
}
