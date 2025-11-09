import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:gps_app/core/api_service/api_consumer.dart';
import 'package:gps_app/core/api_service/end_points.dart';
import 'package:gps_app/core/enums/response_type.dart';
import 'package:gps_app/core/helpers/print_helper.dart';
import 'package:gps_app/core/helpers/snackbar.dart';
import 'package:gps_app/core/models/api_response_model.dart';
import 'package:gps_app/core/service_locator/service_locator.dart';
import 'package:gps_app/features/blogs/models/blog_model/blog_model.dart';

class BlogController {
  final _api = serviceLocator<ApiConsumer>();
  Future<ApiResponseModel<List<BlogModel>>> blogs() async {
    final t = prt('blogs - BlogController');
    try {
      final response = await _api.get(EndPoint.blogs);
      pr(response, '$t - response');
      final List<BlogModel> models =
          (response as List).map((json) => BlogModel.fromJson(json)).toList();
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

  Future<ApiResponseModel<bool>> likeBlog({required int blogId}) async {
    final t = prt('likeBlog - BlogController');
    try {
      final response = await _api.post(
        EndPoint.blogs,
        data: {'blog_id': blogId, 'type': 'like'},
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

  Future<ApiResponseModel<bool>> addComment({
    required int blogId,
    required String content,
  }) async {
    final t = prt('addComment - BlogController');
    try {
      final response = await _api.post(
        EndPoint.blogs,
        data: {'blog_id': blogId, 'type': 'comment', 'comment': content},
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

  Future<ApiResponseModel<bool>> updateComment({
    required int commentId,
    required String content,
  }) async {
    final t = prt('addComment - BlogController');
    try {
      final response = await _api.put(
        "${EndPoint.blogs}/$commentId",
        data: {'type': 'comment', 'comment': content},
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
}
