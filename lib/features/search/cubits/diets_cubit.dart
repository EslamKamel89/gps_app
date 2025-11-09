import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_app/core/enums/response_type.dart';
import 'package:gps_app/core/helpers/print_helper.dart';
import 'package:gps_app/core/models/api_response_model.dart';
import 'package:gps_app/core/service_locator/service_locator.dart';
import 'package:gps_app/features/search/controllers/suggestions_controller.dart';
import 'package:gps_app/features/user/preferences/models/diet_model.dart';

class DietsCubit extends Cubit<ApiResponseModel<List<DietModel>>> {
  DietsCubit() : super(ApiResponseModel());
  final SuggestionsController controller = serviceLocator<SuggestionsController>();
  Future diets() async {
    final t = prt('diets - DietsCubit');
    emit(state.copyWith(errorMessage: null, response: ResponseEnum.loading));
    final ApiResponseModel<List<DietModel>> response = await controller.dietsIndex();
    pr(response, t);
    emit(response);
  }
}
