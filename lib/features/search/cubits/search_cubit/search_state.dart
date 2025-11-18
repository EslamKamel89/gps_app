part of 'search_cubit.dart';

enum SearchStateEnum {
  suggestionSelected,
  currentLocationAvailable,
  allLocationsFetched,
  update,
}

class SearchState {
  LatLng? currentLocation;
  String? search;
  int? distance;
  CategoryModel? category;
  SubCategoryModel? subCategory;
  DietModel? diet;
  List<String>? types;
  ApiResponseModel<List<SuggestionModel>>? suggestions;
  SuggestionModel? selectedSuggestion;
  SearchStateEnum searchStateEnum;
  ApiResponseModel<List<SuggestionModel>>? allLocations;
  StateModel? state;
  DistrictModel? district;
  SearchState({
    this.currentLocation,
    this.search,
    this.distance,
    this.subCategory,
    this.category,
    this.diet,
    this.types,
    this.suggestions,
    this.selectedSuggestion,
    this.searchStateEnum = SearchStateEnum.update,
    this.state,
    this.district,
    this.allLocations,
  });

  Map<String, dynamic> toRequestBody() {
    return {
      "current_location": {
        "latitude": currentLocation?.latitude,
        "longitude": currentLocation?.longitude,
      },
      "search": search,
      "distance": distance,
      "sub_category_id": subCategory?.id,
      "diet_id": diet?.id,
      "type": types,
      "state_id": state?.id,
      "district_id": district?.id,
    };
  }

  SearchState copyWith({
    LatLng? currentLocation,
    String? search,
    int? distance,
    CategoryModel? category,
    SubCategoryModel? subCategory,
    DietModel? diet,
    List<String>? types,
    ApiResponseModel<List<SuggestionModel>>? suggestions,
    SuggestionModel? selectedSuggestion,
    SearchStateEnum? searchStateEnum,
    ApiResponseModel<List<SuggestionModel>>? allLocations,
    StateModel? state,
    DistrictModel? district,
  }) {
    return SearchState(
      currentLocation: currentLocation ?? this.currentLocation,
      search: search ?? this.search,
      distance: distance ?? this.distance,
      category: category ?? this.category,
      subCategory: subCategory ?? this.subCategory,
      diet: diet ?? this.diet,
      types: types ?? this.types,
      suggestions: suggestions ?? this.suggestions,
      selectedSuggestion: selectedSuggestion ?? this.selectedSuggestion,
      searchStateEnum: searchStateEnum ?? this.searchStateEnum,
      state: state ?? this.state,
      district: district ?? this.district,
      allLocations: allLocations ?? this.allLocations,
    );
  }

  @override
  String toString() {
    return 'SearchState(currentLocation: $currentLocation, search: $search, distance: $distance, category: $category, subCategory: $subCategory, diet: $diet, types: $types, suggestions: $suggestions, state: $state, district: $district)';
  }
}
