// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'preferences_cubit.dart';

class PreferencesState {
  ApiResponseModel<List<CategoryModel>> categories;
  ApiResponseModel<List<DietModel>> diets;
  List<CategoryModel> selectedCategories;
  List<SubCategoryModel> selectedSubCategories;
  PreferencesState({
    required this.diets,
    required this.categories,
    required this.selectedCategories,
    required this.selectedSubCategories,
  });
  factory PreferencesState.initial() {
    return PreferencesState(
      categories: ApiResponseModel(),
      diets: ApiResponseModel(),
      selectedCategories: [],
      selectedSubCategories: [],
    );
  }

  PreferencesState copyWith({
    ApiResponseModel<List<CategoryModel>>? categories,
    ApiResponseModel<List<DietModel>>? diets,
    List<CategoryModel>? selectedCategories,
    List<SubCategoryModel>? selectedSubCategories,
  }) {
    return PreferencesState(
      categories: categories ?? this.categories,
      diets: diets ?? this.diets,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      selectedSubCategories: selectedSubCategories ?? this.selectedSubCategories,
    );
  }

  @override
  String toString() =>
      'CategoryState(categories: $categories, selectedCategories: $selectedCategories, selectedSubCategories: $selectedSubCategories)';
}
