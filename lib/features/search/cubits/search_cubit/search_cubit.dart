import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gps_app/core/enums/response_type.dart';
import 'package:gps_app/core/helpers/print_helper.dart';
import 'package:gps_app/core/models/api_response_model.dart';
import 'package:gps_app/core/service_locator/service_locator.dart';
import 'package:gps_app/features/search/controllers/search_controller.dart';
import 'package:gps_app/features/search/models/suggestion_model/suggestion_model.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchController controller = serviceLocator<SearchController>();
  SearchCubit() : super(SearchState());
  Future search() async {
    final t = prt('search - SearchCubit');
    emit(
      state.copyWith(
        suggestions: state.suggestions?.copyWith(
          errorMessage: null,
          response: ResponseEnum.loading,
        ),
      ),
    );
    final ApiResponseModel<List<SuggestionModel>> response = await controller.search(state: state);
    pr(response, t);
    emit(state.copyWith(suggestions: response));
  }
}
