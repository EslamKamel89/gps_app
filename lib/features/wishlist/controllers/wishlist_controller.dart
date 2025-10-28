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
import 'package:gps_app/features/wishlist/models/acceptor_model/wish_model.dart';
import 'package:gps_app/features/wishlist/models/meal_item_model.dart';

class WishListController {
  ApiConsumer api = serviceLocator();
  Future<ApiResponseModel<List<WishModel>>> wishes() async {
    final t = prt('wishes - WishListController');
    try {
      final response = await api.get(EndPoint.wishlist);
      pr(response, '$t - response');
      final List<WishModel> models =
          (response as List).map((json) => WishModel.fromJson(json)).toList();
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

  Future<ApiResponseModel<bool>> addWish({
    required String description,
    int? categoryId,
    int? subCategoryId,
  }) async {
    final t = prt('addWish - WishListController');
    try {
      final response = await api.post(
        EndPoint.wishlist,
        data: {
          "description": description,
          "category_id": categoryId,
          "subcategory_id": subCategoryId,
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

  Future<ApiResponseModel<List<MealItemModel>>> getMealItems() async {
    final t = prt('getMealItems - WishListController');
    try {
      final response = await api.get(EndPoint.mealItems);
      pr(response, '$t - response');
      final List<MealItemModel> models =
          (response as List).map((json) => MealItemModel.fromJson(json)).toList();
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

  Future<ApiResponseModel<bool>> acceptWish({required int wishListId, required int itemId}) async {
    final t = prt('addWish - WishListController');

    try {
      final response = await api.post(
        EndPoint.acceptWishList,
        data: {
          "wishlist_id": wishListId,
          "item_type": userInMemory()?.userType?.type == 'restaurant' ? 'meal' : 'catalogItem',
          "item_id": itemId,
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
}
