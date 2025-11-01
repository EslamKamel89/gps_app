import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:gps_app/core/api_service/api_consumer.dart';
import 'package:gps_app/core/api_service/end_points.dart';
import 'package:gps_app/core/enums/response_type.dart';
import 'package:gps_app/core/helpers/print_helper.dart';
import 'package:gps_app/core/helpers/snackbar.dart';
import 'package:gps_app/core/models/api_response_model.dart';
import 'package:gps_app/core/service_locator/service_locator.dart';
import 'package:gps_app/features/item_info/models/item_info.dart';

class ItemInfoController {
  final _api = serviceLocator<ApiConsumer>();
  Future<ApiResponseModel<ItemInfoEntity>> getItemInfo({
    required int acceptorId,
    required int itemId,
  }) async {
    final t = prt('getItemInfo - ItemInfoController');
    try {
      final response = await _api.get(
        "${EndPoint.itemDetails}/$itemId/$acceptorId",
      );
      pr(response, '$t - response');
      final ItemInfoEntity model = ItemInfoModel.fromJson(response).toEntity();
      return pr(
        ApiResponseModel(response: ResponseEnum.success, data: model),
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
