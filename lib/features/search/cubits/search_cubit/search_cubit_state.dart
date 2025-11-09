part of 'search_cubit_cubit.dart';

class SearchCubitState {
  LatLng? currentLocation;
  String? search;
  int? distance;
  int? subCategoryId;
  int? dietId;
  List<String>? types;
  SearchCubitState({
    this.currentLocation,
    this.search,
    this.distance,
    this.subCategoryId,
    this.dietId,
    this.types,
  });

  SearchCubitState copyWith({
    LatLng? currentLocation,
    String? search,
    int? distance,
    int? subCategoryId,
    int? dietId,
    List<String>? types,
  }) {
    return SearchCubitState(
      currentLocation: currentLocation ?? this.currentLocation,
      search: search ?? this.search,
      distance: distance ?? this.distance,
      subCategoryId: subCategoryId ?? this.subCategoryId,
      dietId: dietId ?? this.dietId,
      types: types ?? this.types,
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
