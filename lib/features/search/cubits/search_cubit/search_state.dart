// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'search_cubit.dart';

class SearchState {
  LatLng? currentLocation;
  String? search;
  int? distance;
  CategoryModel? category;
  SubCategoryModel? subCategory;
  DietModel? diet;
  List<String>? types;
  ApiResponseModel<List<SuggestionModel>>? suggestions;
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
