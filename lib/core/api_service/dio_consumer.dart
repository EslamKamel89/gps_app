// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:dio/dio.dart';
import 'package:gps_app/core/Errors/exception.dart';
import 'package:gps_app/core/api_service/api_consumer.dart';
import 'package:gps_app/core/api_service/api_interceptors.dart';
import 'package:gps_app/core/api_service/check_internet.dart';
import 'package:gps_app/core/api_service/end_points.dart';
import 'package:gps_app/core/cache/local_storage.dart';
import 'package:gps_app/core/service_locator/service_locator.dart';
import 'package:gps_app/features/auth/models/user_model.dart';

class DioConsumer extends ApiConsumer {
  final Dio dio;
  final localStorage = serviceLocator<LocalStorage>();
  DioConsumer({required this.dio}) {
    dio.options.baseUrl = EndPoint.baseUrl;
    dio.options.connectTimeout = const Duration(seconds: 60);
    dio.options.receiveTimeout = const Duration(seconds: 60);
    dio.options.headers = {"Content-Type": "application/json", "Accept": "application/json"};
    dio.interceptors.add(DioInterceptor());
    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
      ),
    );
  }

  @override
  Future get(String path, {Object? data, Map<String, dynamic>? queryParameter}) async {
    _setAuthorizationHeader();
    try {
      if (!(await checkInternet())) {
        throw OfflineException();
      }
      final response = await dio.get(path, data: data, queryParameters: queryParameter);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameter,
    bool isFormData = false,
  }) async {
    _setAuthorizationHeader();
    try {
      if (!(await checkInternet())) {
        throw OfflineException();
      }
      final response = await dio.delete(
        path,
        data: isFormData ? FormData.fromMap(data) : data,
        queryParameters: queryParameter,
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameter,
    bool isFormData = false,
  }) async {
    _setAuthorizationHeader();
    try {
      if (!(await checkInternet())) {
        throw OfflineException();
      }
      final response = await dio.patch(
        path,
        data: isFormData ? FormData.fromMap(data) : data,
        queryParameters: queryParameter,
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameter,
    bool isFormData = false,
  }) async {
    _setAuthorizationHeader();
    try {
      if (!(await checkInternet())) {
        throw OfflineException();
      }
      final response = await dio.post(
        path,
        data: isFormData ? FormData.fromMap(data) : data,
        queryParameters: queryParameter,
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  void _setAuthorizationHeader() {
    final UserModel? user = localStorage.cachedUser;
    // pr(user, 'user');
    if (user == null) {
      dio.options.headers.remove('Authorization');
    } else {
      final token = user.token;
      dio.options.headers.addAll({"Authorization": 'Bearer $token'});
    }
  }
}
