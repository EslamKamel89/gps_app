import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_app/core/cache/local_storage.dart';
import 'package:gps_app/core/enums/response_type.dart';
import 'package:gps_app/core/models/api_response_model.dart';
import 'package:gps_app/core/service_locator/service_locator.dart';
import 'package:gps_app/features/auth/models/user_register_param.dart';

import '../controllers/auth_controller.dart';
import '../models/user_model.dart';

class UserRegisterCubit extends Cubit<ApiResponseModel<UserModel>> {
  UserRegisterCubit() : super(ApiResponseModel());

  final _controller = serviceLocator<AuthController>();
  final _storage = serviceLocator<LocalStorage>();

  Future<void> register({required UserRegisterParam param}) async {
    emit(state.copyWith(response: ResponseEnum.loading));
    final res = await _controller.userRegister(param: param);
    if (res.response == ResponseEnum.success && res.data != null) {
      await _storage.cacheUser(res.data);
    }
    emit(res);
  }
}
