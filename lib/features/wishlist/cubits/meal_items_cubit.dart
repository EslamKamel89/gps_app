import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_app/core/enums/response_type.dart';
import 'package:gps_app/core/helpers/print_helper.dart';
import 'package:gps_app/core/models/api_response_model.dart';
import 'package:gps_app/core/service_locator/service_locator.dart';
import 'package:gps_app/features/wishlist/controllers/wishlist_controller.dart';
import 'package:gps_app/features/wishlist/models/meal_item_model.dart';

class MealItemsCubit extends Cubit<ApiResponseModel<List<MealItemModel>>> {
  MealItemsCubit() : super(ApiResponseModel());
  final WishListController controller = serviceLocator<WishListController>();
  Future getMealItems() async {
    final t = prt('getMealItems - MealItemsCubit');
    emit(state.copyWith(errorMessage: null, response: ResponseEnum.loading));
    final ApiResponseModel<List<MealItemModel>> response =
        await controller.getMealItems();
    pr(response, t);
    emit(response);
  }

  MealItemModel? selectItem(String itemName) {
    final item = state.data?.where((c) => itemName == c.name).first;
    return item;
  }
}
