import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_app/core/enums/response_type.dart';
import 'package:gps_app/core/helpers/print_helper.dart';
import 'package:gps_app/core/models/api_response_model.dart';
import 'package:gps_app/core/service_locator/service_locator.dart';
import 'package:gps_app/features/favorites/controller/favorites_controller.dart';
import 'package:gps_app/features/favorites/models/favorite_model.dart';

class FavoritesCubit extends Cubit<ApiResponseModel<List<FavoriteModel>>> {
  FavoritesCubit() : super(ApiResponseModel());
  final FavoritesController controller = serviceLocator<FavoritesController>();
  Future favorites() async {
    final t = prt('favorites - FavoritesCubit');
    emit(state.copyWith(errorMessage: null, response: ResponseEnum.loading));
    final ApiResponseModel<List<FavoriteModel>> response = await controller.favorites();
    pr(response, t);
    emit(response);
  }

  Future<ApiResponseModel<bool>> removeFromFavorites(FavoriteModel fav) async {
    state.data?.remove(fav);
    emit(state.copyWith());
    final ApiResponseModel<bool> response = await controller.removeFromFavorite(id: fav.id);
    favorites();
    return response;
  }
}
