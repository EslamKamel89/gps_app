import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_app/core/enums/response_type.dart';
import 'package:gps_app/core/helpers/print_helper.dart';
import 'package:gps_app/core/models/api_response_model.dart';
import 'package:gps_app/core/service_locator/service_locator.dart';
import 'package:gps_app/features/about/controller/about_controller.dart';
import 'package:gps_app/features/about/models/about_model.dart';

class AboutCubit extends Cubit<ApiResponseModel<AboutModel>> {
  AboutCubit() : super(ApiResponseModel());
  final AboutController controller = serviceLocator<AboutController>();
  Future about() async {
    final t = prt('about - AboutCubit');
    emit(state.copyWith(errorMessage: null, response: ResponseEnum.loading));
    final ApiResponseModel<AboutModel> response = await controller.getAbout();
    pr(response, t);
    emit(response);
  }
}
