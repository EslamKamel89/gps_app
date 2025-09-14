import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_app/core/cache/cache_keys.dart';
import 'package:gps_app/core/cache/local_storage.dart';
import 'package:gps_app/core/enums/response_type.dart';
import 'package:gps_app/core/models/api_response_model.dart';
import 'package:gps_app/core/service_locator/service_locator.dart';

import '../controllers/auth_controller.dart';
import '../models/user_model.dart';

class AuthCubit extends Cubit<ApiResponseModel<UserModel>> {
  AuthCubit() : super(ApiResponseModel());

  final _controller = serviceLocator<AuthController>();
  final _storage = serviceLocator<LocalStorage>();

  Future<void> login({required String email, required String password}) async {
    emit(state.copyWith(response: ResponseEnum.loading));
    final res = await _controller.login(email: email, password: password);
    if (res.response == ResponseEnum.success && res.data != null) {
      final jsonStr = jsonEncode(res.data!.toJson());
      await _storage.setString(CacheKeys.userJson, jsonStr);
    }
    emit(res);
  }

  /// Synchronous read of cached user (if needed elsewhere)
  UserModel? get cachedUser {
    final raw = _storage.getString(CacheKeys.userJson);
    if (raw == null) return null;
    try {
      return UserModel.fromJson(jsonDecode(raw));
    } catch (_) {
      return null;
    }
  }

  Future<void> logout() async {
    await _storage.remove(CacheKeys.userJson);
    emit(ApiResponseModel());
  }
}
