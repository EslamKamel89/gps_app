import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_app/core/enums/response_type.dart';
import 'package:gps_app/core/helpers/print_helper.dart';
import 'package:gps_app/core/models/api_response_model.dart';
import 'package:gps_app/core/service_locator/service_locator.dart';
import 'package:gps_app/features/wishlist/controllers/wishlist_controller.dart';
import 'package:gps_app/features/wishlist/models/wish_model.dart';

class WishesCubit extends Cubit<ApiResponseModel<List<WishModel>>> {
  WishesCubit() : super(ApiResponseModel());
  final WishListController controller = serviceLocator<WishListController>();
  Future wishes() async {
    final t = prt('wishes - WishesCubit');
    emit(state.copyWith(errorMessage: null, response: ResponseEnum.loading));
    final ApiResponseModel<List<WishModel>> response = await controller.wishes();
    pr(response, t);
    emit(response);
  }

  Future addWish({required String description, int? categoryId, int? subCategoryId}) async {
    final t = prt('addWish - WishesCubit');
    final ApiResponseModel<bool> response = await controller.addWish(
      categoryId: categoryId,
      subCategoryId: subCategoryId,
      description: description,
    );
    if (response.response == ResponseEnum.success) {
      await wishes();
    }
  }
}
