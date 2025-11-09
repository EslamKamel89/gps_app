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
  SearchState({
    this.currentLocation,
    this.search,
    this.distance,
    this.subCategory,
    this.category,
    this.diet,
    this.types,
    this.suggestions,
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
    );
  }

  @override
  String toString() {
    return 'SearchState(currentLocation: $currentLocation, search: $search, distance: $distance, category: $category, subCategory: $subCategory, diet: $diet, types: $types, suggestions: $suggestions)';
  }
}
