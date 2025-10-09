import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_app/core/cache/local_storage.dart';
import 'package:gps_app/core/enums/response_type.dart';
import 'package:gps_app/core/helpers/print_helper.dart';
import 'package:gps_app/core/models/api_response_model.dart';
import 'package:gps_app/core/service_locator/service_locator.dart';
import 'package:gps_app/features/auth/controllers/auth_controller.dart';
import 'package:gps_app/features/auth/models/menu_param/meal_param.dart';
import 'package:gps_app/features/auth/models/menu_param/menu_param.dart';
import 'package:gps_app/features/auth/models/user_model.dart';

part 'create_restaurant_menus_state.dart';

class CreateRestaurantMenusCubit extends Cubit<CreateRestaurantMenusState> {
  final controller = serviceLocator<AuthController>();
  CreateRestaurantMenusCubit() : super(CreateRestaurantMenusState.initial());

  void addMeal({required MenuParam menuParam, required MealParam mealParam}) {
    menuParam.meals ??= [];
    menuParam.meals!.add(mealParam);
    emit(state.copyWith());
  }

  void removeMeal({
    required MenuParam menuParam,
    required MealParam mealParam,
  }) {
    menuParam.meals ??= [];
    menuParam.meals!.remove(mealParam);
    emit(state.copyWith());
  }

  void addMenu({required MenuParam menuParam}) {
    state.menus.add(menuParam);
    emit(state.copyWith());
  }

  void removeMenu({required MenuParam menuParam}) {
    state.menus.remove(menuParam);
    emit(state.copyWith());
  }

  Future createMenus() async {
    final t = prt('createMenus - CreateRestaurantMenusCubit');
    UserModel? user = serviceLocator<LocalStorage>().cachedUser;
    for (var m in state.menus) {
      m.restaurantId = user?.restaurant?.id;
    }
    pr(state.menus, 'state.menus');
    // return;
    emit(
      state.copyWith(
        menusResponse: state.menusResponse.copyWith(
          errorMessage: null,
          response: ResponseEnum.loading,
          data: null,
        ),
      ),
    );
    final ApiResponseModel<bool> response = await controller
        .createRestaurantMenus(param: state.menus);
    pr(response, t);
    emit(state.copyWith(menusResponse: response));
  }
}
