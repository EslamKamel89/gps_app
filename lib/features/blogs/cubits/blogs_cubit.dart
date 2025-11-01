import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gps_app/core/enums/response_type.dart';
import 'package:gps_app/core/helpers/print_helper.dart';
import 'package:gps_app/core/models/api_response_model.dart';
import 'package:gps_app/core/service_locator/service_locator.dart';
import 'package:gps_app/features/blogs/controllers/blog_controller.dart';
import 'package:gps_app/features/blogs/models/blog_model/blog_model.dart';

class BlogsCubit extends Cubit<ApiResponseModel<List<BlogModel>>> {
  BlogsCubit() : super(ApiResponseModel());
  final BlogController controller = serviceLocator<BlogController>();
  Future blogs() async {
    final t = prt('blogs - BlogsCubit');
    emit(state.copyWith(errorMessage: null, response: ResponseEnum.loading));
    final ApiResponseModel<List<BlogModel>> response = await controller.blogs();
    pr(response, t);
    emit(response);
  }
}
