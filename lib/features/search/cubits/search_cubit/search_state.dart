part of 'search_cubit.dart';

class SearchState {
  LatLng? currentLocation;
  String? search;
  int? distance;
  int? subCategoryId;
  int? dietId;
  List<String>? types;
  ApiResponseModel<List<SuggestionModel>>? suggestions;
  SearchState({
    this.currentLocation,
    this.search,
    this.distance,
    this.subCategoryId,
    this.dietId,
    this.types,
    this.suggestions,
  });

  SearchState copyWith({
    LatLng? currentLocation,
    String? search,
    int? distance,
    int? subCategoryId,
    int? dietId,
    List<String>? types,
    ApiResponseModel<List<SuggestionModel>>? suggestions,
  }) {
    return SearchState(
      currentLocation: currentLocation ?? this.currentLocation,
      search: search ?? this.search,
      distance: distance ?? this.distance,
      subCategoryId: subCategoryId ?? this.subCategoryId,
      dietId: dietId ?? this.dietId,
      types: types ?? this.types,
      suggestions: suggestions ?? this.suggestions,
    );
  }

  Map<String, dynamic> toRequestBody() {
    return {
      "current_location": {
        "latitude": currentLocation?.latitude,
        "longitude": currentLocation?.longitude,
      },
      "search": search,
      "distance": distance,
      "sub_category_id": subCategoryId,
      "diet_id": dietId,
      "type": types,
    };
  }
}
