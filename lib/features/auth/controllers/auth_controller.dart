import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:gps_app/core/api_service/api_consumer.dart';
import 'package:gps_app/core/api_service/end_points.dart';
import 'package:gps_app/core/enums/response_type.dart';
import 'package:gps_app/core/helpers/print_helper.dart';
import 'package:gps_app/core/helpers/snackbar.dart';
import 'package:gps_app/core/models/api_response_model.dart';
import 'package:gps_app/core/service_locator/service_locator.dart';

import '../models/user_model.dart';

class AuthController {
  final _api = serviceLocator<ApiConsumer>();

  Future<ApiResponseModel<UserModel>> login({
    required String email,
    required String password,
  }) async {
    final t = 'AuthController - login';
    try {
      final res = await _api.post(EndPoint.login, data: {'email': email, 'password': password});
      final user = UserModel.fromJson(res.data as Map<String, dynamic>);
      pr(user, t);
      return ApiResponseModel<UserModel>(data: user, response: ResponseEnum.success);
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
