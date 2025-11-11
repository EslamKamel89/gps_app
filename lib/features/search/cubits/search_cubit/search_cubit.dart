import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gps_app/core/enums/response_type.dart';
import 'package:gps_app/core/helpers/get_current_location.dart';
import 'package:gps_app/core/helpers/print_helper.dart';
import 'package:gps_app/core/models/api_response_model.dart';
import 'package:gps_app/core/service_locator/service_locator.dart';
import 'package:gps_app/features/auth/models/district_model.dart';
import 'package:gps_app/features/auth/models/state_model.dart';
import 'package:gps_app/features/search/controllers/suggestions_controller.dart';
import 'package:gps_app/features/search/models/suggestion_model/suggestion_model.dart';
import 'package:gps_app/features/user/preferences/models/category_model/category_model.dart';
import 'package:gps_app/features/user/preferences/models/category_model/sub_category_model.dart';
import 'package:gps_app/features/user/preferences/models/diet_model.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SuggestionsController controller = serviceLocator<SuggestionsController>();
  SearchCubit() : super(SearchState());
  Future init() async {
    await _currentLocation();
    getAllLocations();
  }

  Future _currentLocation() async {
    final location = await getCurrentLocation();
    if (location != null) {
      emit(
        state.copyWith(
          currentLocation: location,
          searchStateEnum: SearchStateEnum.currentLocationAvailable,
        ),
      );
    }
  }

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
    response.data =
        response.data?.where((s) {
          if (state.distance == null || s.distance == null) return true;
          return s.distance! < state.distance!;
        }).toList();
    pr(response, t);
    emit(state.copyWith(suggestions: response));
  }

  Future getAllLocations() async {
    final t = prt('getAllLocations - SearchCubit');
    emit(
      state.copyWith(
        searchStateEnum: SearchStateEnum.allLocationsFetched,
        allLocations: state.allLocations?.copyWith(
          errorMessage: null,
          response: ResponseEnum.loading,
        ),
      ),
    );
    final ApiResponseModel<List<SuggestionModel>> response = await controller.search(
      state: SearchState(),
    );
    pr(response, t);
    emit(state.copyWith(allLocations: response));
  }

  void selectSuggestion(SuggestionModel suggestion) {
    emit(
      state.copyWith(
        selectedSuggestion: suggestion,
        searchStateEnum: SearchStateEnum.suggestionSelected,
      ),
    );
  }

  void update() {
    emit(state.copyWith());
  }
}
