import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:gps_app/core/api_service/api_consumer.dart';
import 'package:gps_app/core/api_service/end_points.dart';
import 'package:gps_app/core/enums/response_type.dart';
import 'package:gps_app/core/helpers/print_helper.dart';
import 'package:gps_app/core/helpers/snackbar.dart';
import 'package:gps_app/core/helpers/user.dart';
import 'package:gps_app/core/models/api_response_model.dart';
import 'package:gps_app/core/service_locator/service_locator.dart';
import 'package:gps_app/features/user/restaurant_details/models/restaurant_detailed_model/export.dart';
import 'package:gps_app/features/user/restaurant_details/models/restaurant_main_data.dart';

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

  Future<ApiResponseModel<RestaurantDetailedModel>> restaurant({required int restaurantId}) async {
    final t = prt('restaurant - RestaurantsController');
    try {
      final response = await _api.get("${EndPoint.restaurants}/$restaurantId");
      pr(response, '$t - response');
      final RestaurantDetailedModel model = RestaurantDetailedModel.fromJson(response);
      // return pr(ApiResponseModel(response: ResponseEnum.success, data: demoModel), t);
      pr(model.certifications?.length, 'certs length');
      return pr(ApiResponseModel(response: ResponseEnum.success, data: model), t);
    } catch (e) {
      String errorMessage = e.toString();
      if (e is DioException) {
        errorMessage = jsonEncode(e.response?.data ?? 'Unknown error occurred');
      }
      showSnackbar('Error', errorMessage, true);
      return pr(ApiResponseModel(errorMessage: errorMessage, response: ResponseEnum.failed), t);
    }
  }

  Future<ApiResponseModel<bool>> addMenu({required Menu menu}) async {
    final t = prt('addMenu - RestaurantsController');
    try {
      final response = await _api.post(
        "${EndPoint.addRestaurantMenus}/",
        data: {"name": menu.name, "description": menu.description},
      );
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

  Future<ApiResponseModel<bool>> deleteMenu({required Menu menu}) async {
    final t = prt('deleteMenu - RestaurantsController');
    try {
      final response = await _api.delete("${EndPoint.restaurantMenus}/${menu.id}");
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

  Future<ApiResponseModel<bool>> addMeal({required Menu menu, required Meal meal}) async {
    final t = prt('addMeal - RestaurantsController');
    try {
      final response = await _api.post(
        "${EndPoint.addMeal}/",
        data: {
          "restaurant_menu_id": menu.id,
          "name": meal.name,
          "description": meal.description,
          "price": meal.price,
          "image_id": meal.images?.id,
          "category_id": meal.categories?.id,
          "sub_category_id": meal.subcategories?.id,
        },
      );
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

  Future<ApiResponseModel<bool>> deleteMeal({required Meal meal}) async {
    final t = prt('deleteMeal - RestaurantsController');
    try {
      final response = await _api.delete("${EndPoint.addMeal}/${meal.id}");
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

  Future<ApiResponseModel<bool>> deleteBranch({required Branch? branch}) async {
    final t = prt('deleteBranch - RestaurantsController');
    try {
      final response = await _api.delete("${EndPoint.branches}/${branch?.id}");
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

  Future<ApiResponseModel<bool>> addBranch({required Branch? branch}) async {
    final t = prt('addBranch - RestaurantsController');
    try {
      final Map<String, dynamic> body = branch?.toRequestBody() ?? {};
      body.addEntries({'restaurant_id': userInMemory()?.restaurant?.id}.entries);
      final response = await _api.post("${EndPoint.branches}/", data: body);
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

  Future<ApiResponseModel<bool>> deleteCertification({
    required Certification? certification,
  }) async {
    final t = prt('deleteCertification - RestaurantsController');
    try {
      final response = await _api.delete("${EndPoint.restaurantCertificates}/${certification?.id}");
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
