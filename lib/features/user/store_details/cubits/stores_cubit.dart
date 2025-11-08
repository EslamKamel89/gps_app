import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_app/core/enums/response_type.dart';
import 'package:gps_app/core/helpers/print_helper.dart';
import 'package:gps_app/core/models/api_response_model.dart';
import 'package:gps_app/core/service_locator/service_locator.dart';
import 'package:gps_app/features/auth/models/user_model.dart';
import 'package:gps_app/features/user/store_details/controllers/store_controller.dart';

class StoresCubit extends Cubit<ApiResponseModel<List<UserModel>>> {
  StoresCubit() : super(ApiResponseModel());
  final StoreController controller = serviceLocator<StoreController>();
  Future stores({required bool isStore}) async {
    final t = prt('stores - StoresCubit');
    emit(state.copyWith(errorMessage: null, response: ResponseEnum.loading));
    final ApiResponseModel<List<UserModel>> response = await controller.stores(isStore: isStore);
    pr(response, t);
    emit(response);
  }
}
