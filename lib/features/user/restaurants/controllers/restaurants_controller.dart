import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:gps_app/core/api_service/api_consumer.dart';
import 'package:gps_app/core/api_service/end_points.dart';
import 'package:gps_app/core/enums/response_type.dart';
import 'package:gps_app/core/helpers/print_helper.dart';
import 'package:gps_app/core/helpers/snackbar.dart';
import 'package:gps_app/core/models/api_response_model.dart';
import 'package:gps_app/core/service_locator/service_locator.dart';
import 'package:gps_app/features/user/restaurants/models/restaurant_main_data.dart';

class RestaurantsController {
  final _api = serviceLocator<ApiConsumer>();
  Future<ApiResponseModel<List<RestaurantMainData>>> restaurants() async {
    final t = prt('restaurants - RestaurantsController');
    try {
      final response = await _api.get(EndPoint.restaurants);
      pr(response, '$t - response');
      final List<RestaurantMainData> models =
          (response['unverified'] as List)
              .map((json) => RestaurantMainData.fromJson(json))
              .toList();
      return pr(
        ApiResponseModel(response: ResponseEnum.success, data: models),
        t,
      );
    } catch (e) {
      String errorMessage = e.toString();
      if (e is DioException) {
        errorMessage = jsonEncode(e.response?.data ?? 'Unknown error occurred');
      }
      showSnackbar('Error', errorMessage, true);
      return pr(
        ApiResponseModel(
          errorMessage: errorMessage,
          response: ResponseEnum.failed,
        ),
        t,
      );
    }
  }
}
