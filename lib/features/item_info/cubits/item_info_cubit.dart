import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_app/core/enums/response_type.dart';
import 'package:gps_app/core/helpers/print_helper.dart';
import 'package:gps_app/core/models/api_response_model.dart';
import 'package:gps_app/core/service_locator/service_locator.dart';
import 'package:gps_app/features/item_info/controllers/item_info_controller.dart';
import 'package:gps_app/features/item_info/models/item_info.dart';

class ItemInfoCubit extends Cubit<ApiResponseModel<ItemInfoEntity>> {
  ItemInfoCubit() : super(ApiResponseModel());
  final ItemInfoController controller = serviceLocator<ItemInfoController>();
  Future getItem({String? type, int? acceptorId, required int itemId}) async {
    final t = prt('getItem - ItemInfoCubit');
    emit(state.copyWith(errorMessage: null, response: ResponseEnum.loading));
    final ApiResponseModel<ItemInfoEntity> response = await controller.getItemInfo(
      type: type,
      acceptorId: acceptorId,
      itemId: itemId,
    );
    pr(response, t);
    emit(response);
  }
}
