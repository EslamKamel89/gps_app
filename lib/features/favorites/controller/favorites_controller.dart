import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:gps_app/core/api_service/api_consumer.dart';
import 'package:gps_app/core/api_service/end_points.dart';
import 'package:gps_app/core/enums/response_type.dart';
import 'package:gps_app/core/helpers/print_helper.dart';
import 'package:gps_app/core/helpers/snackbar.dart';
import 'package:gps_app/core/models/api_response_model.dart';
import 'package:gps_app/core/service_locator/service_locator.dart';
import 'package:gps_app/features/favorites/models/favorite_model.dart';

class FavoritesController {
  final _api = serviceLocator<ApiConsumer>();
  Future<ApiResponseModel<List<FavoriteModel>>> favorites() async {
    final t = prt('favorites - FavoritesController');
    try {
      final response = await _api.get(EndPoint.favorites);
      pr(response, '$t - response');
      final List<FavoriteModel> models =
          (response as List)
              .map((json) => FavoriteModel.fromJson(json))
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

  Future<ApiResponseModel<bool>> addToFavorite({
    required int id,
    required String type,
  }) async {
    final t = prt('addToFavorite - FavoritesController');
    try {
      final response = await _api.post(
        EndPoint.favorites,
        data: {"favourite_id": id, "favourite_type": type},
      );
      pr(response, '$t - response');
      return pr(
        ApiResponseModel(response: ResponseEnum.success, data: true),
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

  Future<ApiResponseModel<bool>> removeFromFavorite({required int? id}) async {
    final t = prt('removeFromFavorite - FavoritesController');
    try {
      final response = await _api.delete("${EndPoint.favorites}/$id");
      pr(response, '$t - response');
      return pr(
        ApiResponseModel(response: ResponseEnum.success, data: true),
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
