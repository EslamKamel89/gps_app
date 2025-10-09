// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'create_restaurant_menus_cubit.dart';

class CreateRestaurantMenusState {
  ApiResponseModel<bool> menusResponse;
  List<MenuParam> menus;
  CreateRestaurantMenusState({
    required this.menusResponse,
    required this.menus,
  });

  CreateRestaurantMenusState copyWith({
    ApiResponseModel<bool>? menusResponse,
    List<MenuParam>? menus,
  }) {
    return CreateRestaurantMenusState(
      menusResponse: menusResponse ?? this.menusResponse,
      menus: menus ?? this.menus,
    );
  }

  @override
  String toString() =>
      'CreateRestaurantMenusState(menusResponse: $menusResponse, menus: $menus)';

  factory CreateRestaurantMenusState.initial() {
    return CreateRestaurantMenusState(
      menus: [
        MenuParam(meals: [MealParam()]),
      ],
      menusResponse: ApiResponseModel(),
    );
  }
}
