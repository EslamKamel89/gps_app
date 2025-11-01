import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:gps_app/core/api_service/api_consumer.dart';
import 'package:gps_app/core/api_service/end_points.dart';
import 'package:gps_app/core/enums/response_type.dart';
import 'package:gps_app/core/helpers/print_helper.dart';
import 'package:gps_app/core/helpers/snackbar.dart';
import 'package:gps_app/core/models/api_response_model.dart';
import 'package:gps_app/core/service_locator/service_locator.dart';
import 'package:gps_app/features/auth/models/catalog_item_model.dart';
import 'package:gps_app/features/auth/models/catalog_section_model.dart';

class StoreController {
  final _api = serviceLocator<ApiConsumer>();
  Future<ApiResponseModel<bool>> addSection({
    required CatalogSectionModel section,
  }) async {
    final t = prt('addSection - StoreController');
    try {
      final response = await _api.post(
        "${EndPoint.sections}/",
        data: {"name": section.name},
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

  Future<ApiResponseModel<bool>> deleteSection({
    required CatalogSectionModel section,
  }) async {
    final t = prt('deleteSection - StoreController');
    try {
      final response = await _api.delete("${EndPoint.sections}/${section.id}");
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

  Future<ApiResponseModel<bool>> addItem({
    required CatalogItemModel item,
  }) async {
    final t = prt('addItem - StoreController');
    try {
      final response = await _api.post(
        "${EndPoint.items}/",
        data: item.toRequestBody(),
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

  Future<ApiResponseModel<bool>> deleteItem({
    required CatalogItemModel item,
  }) async {
    final t = prt('deleteItem - StoreController');
    try {
      final response = await _api.delete("${EndPoint.items}/${item.id}");
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
