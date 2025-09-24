import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:gps_app/core/api_service/api_consumer.dart';
import 'package:gps_app/core/api_service/end_points.dart';
import 'package:gps_app/core/enums/response_type.dart';
import 'package:gps_app/core/helpers/print_helper.dart';
import 'package:gps_app/core/helpers/snackbar.dart';
import 'package:gps_app/core/models/api_response_model.dart';
import 'package:gps_app/core/service_locator/service_locator.dart';
import 'package:gps_app/features/auth/models/catalog_section_model.dart';
import 'package:gps_app/features/auth/models/catalog_section_param/catalog_section_param.dart';
import 'package:gps_app/features/auth/models/district_model.dart';
import 'package:gps_app/features/auth/models/holiday_model.dart';
import 'package:gps_app/features/auth/models/state_model.dart';
import 'package:gps_app/features/auth/models/user_register_param.dart';
import 'package:gps_app/features/auth/models/vendor_register_params/vendor_register_params.dart';

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
      final user = UserModel.fromJson(res as Map<String, dynamic>);
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

  Future<ApiResponseModel<List<StateModel>>> states() async {
    final t = prt('states - AuthController');
    try {
      final response = await _api.get(EndPoint.states);
      pr(response, '$t - response');
      final List<StateModel> models =
          (response as List).map((json) => StateModel.fromJson(json)).toList();
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

  Future<ApiResponseModel<List<HolidayModel>>> holidays() async {
    final t = prt('holidays - AuthController');
    try {
      final response = await _api.get(EndPoint.holidays);
      pr(response, '$t - response');
      final List<HolidayModel> models =
          (response as List).map((json) => HolidayModel.fromJson(json)).toList();
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

  Future<ApiResponseModel<List<DistrictModel>>> districts({required int stateId}) async {
    final t = prt('districts - AuthController');
    try {
      final response = await _api.get(EndPoint.districts, queryParameter: {'state_id': stateId});
      pr(response, '$t - response');
      final List<DistrictModel> models =
          (response as List).map((json) => DistrictModel.fromJson(json)).toList();
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

  Future<ApiResponseModel<UserModel>> userRegister({required UserRegisterParam param}) async {
    final t = prt('userRegister - AuthController');
    try {
      final response = await _api.post(EndPoint.userRegister, data: param.toJson());
      pr(response, '$t - response');
      final UserModel model = UserModel.fromJson(response);
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

  Future<ApiResponseModel<UserModel>> vendorRegister({required VendorRegisterParams param}) async {
    final t = prt('vendorRegister - AuthController');
    try {
      final response = await _api.post(EndPoint.vendorRegister, data: param.toJson());
      pr(response, '$t - response');
      final UserModel model = UserModel.fromJson(response);
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

  Future<ApiResponseModel<List<CatalogSectionModel>>> createCatalogSection({
    required List<CatalogSectionParam> param,
  }) async {
    final t = prt('createCatalogSection - AuthController');
    try {
      final response = await _api.post(
        EndPoint.vendorCatalogSection,
        data: param.map((e) => e.toJson()).toList(),
      );
      pr(response, '$t - response');
      final List<CatalogSectionModel> models =
          (response as List<dynamic>).map((json) => CatalogSectionModel.fromJson(json)).toList();
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

  Future<ApiResponseModel<bool>> verifyOtp({required String code}) async {
    final t = prt('verifyOtp - AuthController');
    try {
      final response = await _api.post(EndPoint.otpVerify, data: {"code": int.parse(code)});
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
