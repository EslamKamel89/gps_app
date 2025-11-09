// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'preferences_cubit.dart';

class PreferencesState {
  ApiResponseModel<List<CategoryModel>> categories;
  ApiResponseModel<List<DietModel>> diets;
  List<CategoryModel> selectedCategories;
  List<SubCategoryModel> selectedSubCategories;
  List<DietModel> selectedDiets;
  PreferencesState({
    required this.diets,
    required this.categories,
    required this.selectedCategories,
    required this.selectedSubCategories,
    required this.selectedDiets,
  });
  factory PreferencesState.initial() {
    return PreferencesState(
      categories: ApiResponseModel(),
      diets: ApiResponseModel(),
      selectedCategories: [],
      selectedSubCategories: [],
      selectedDiets: [],
    );
  }

  PreferencesState copyWith({
    ApiResponseModel<List<CategoryModel>>? categories,
    ApiResponseModel<List<DietModel>>? diets,
    List<CategoryModel>? selectedCategories,
    List<SubCategoryModel>? selectedSubCategories,
    List<DietModel>? selectedDiets,
  }) {
    return PreferencesState(
      categories: categories ?? this.categories,
      diets: diets ?? this.diets,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      selectedSubCategories:
          selectedSubCategories ?? this.selectedSubCategories,
      selectedDiets: selectedDiets ?? this.selectedDiets,
    );
  }

  @override
  String toString() =>
      'CategoryState(categories: $categories, selectedCategories: $selectedCategories, selectedSubCategories: $selectedSubCategories, selectedDiets: $selectedDiets)';
}
