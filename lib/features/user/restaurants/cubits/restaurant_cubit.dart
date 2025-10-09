import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_app/core/enums/response_type.dart';
import 'package:gps_app/core/helpers/print_helper.dart';
import 'package:gps_app/core/models/api_response_model.dart';
import 'package:gps_app/core/service_locator/service_locator.dart';
import 'package:gps_app/features/user/restaurants/controllers/restaurants_controller.dart';
import 'package:gps_app/features/user/restaurants/models/restaurant_detailed_model/import.dart';

class RestaurantCubit extends Cubit<ApiResponseModel<RestaurantDetailedModel>> {
  RestaurantCubit() : super(ApiResponseModel());
  final RestaurantsController controller = serviceLocator<RestaurantsController>();
  Future restaurant({required int restaurantId}) async {
    final t = prt('restaurantsIndex - RestaurantsCubit');
    emit(state.copyWith(errorMessage: null, response: ResponseEnum.loading));
    final ApiResponseModel<RestaurantDetailedModel> response = await controller.restaurant(
      restaurantId: restaurantId,
    );
    pr(response, t);
    emit(response);
  }
}
