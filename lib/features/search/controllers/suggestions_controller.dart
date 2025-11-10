import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:gps_app/core/api_service/api_consumer.dart';
import 'package:gps_app/core/api_service/end_points.dart';
import 'package:gps_app/core/enums/response_type.dart';
import 'package:gps_app/core/helpers/print_helper.dart';
import 'package:gps_app/core/helpers/snackbar.dart';
import 'package:gps_app/core/models/api_response_model.dart';
import 'package:gps_app/core/service_locator/service_locator.dart';
import 'package:gps_app/features/search/cubits/search_cubit/search_cubit.dart';
import 'package:gps_app/features/search/models/suggestion_model/suggestion_model.dart';
import 'package:gps_app/features/user/preferences/models/diet_model.dart';

class SuggestionsController {
  final api = serviceLocator<ApiConsumer>();

  Future<ApiResponseModel<List<DietModel>>> dietsIndex() async {
    final t = prt('dietsIndex - SearchController');
    try {
      final response = await api.get(EndPoint.diet);
      pr(response, '$t - response');
      final List<DietModel> models =
          (response as List).map((json) => DietModel.fromJson(json)).toList();
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

  Future<ApiResponseModel<List<SuggestionModel>>> search({required SearchState state}) async {
    final t = prt('suggestions - SearchController');
    try {
      final response = await api.post(EndPoint.search, data: state.toRequestBody());
      pr(response, '$t - response');
      final List<SuggestionModel> models =
          (response['search_cards'] as List).map((json) => SuggestionModel.fromJson(json)).toList();
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
}
