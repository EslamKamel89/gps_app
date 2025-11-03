// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'category_onboarding_cubit.dart';

class CategoryOnboardingState {
  ApiResponseModel<List<CategoryModel>> categories;
  ApiResponseModel<List<DietModel>> diets;
  List<CategoryModel> selectedCategories;
  List<SubCategoryModel> selectedSubCategories;
  CategoryOnboardingState({
    required this.diets,
    required this.categories,
    required this.selectedCategories,
    required this.selectedSubCategories,
  });
  factory CategoryOnboardingState.initial() {
    return CategoryOnboardingState(
      categories: ApiResponseModel(),
      diets: ApiResponseModel(),
      selectedCategories: [],
      selectedSubCategories: [],
    );
  }

  CategoryOnboardingState copyWith({
    ApiResponseModel<List<CategoryModel>>? categories,
    ApiResponseModel<List<DietModel>>? diets,
    List<CategoryModel>? selectedCategories,
    List<SubCategoryModel>? selectedSubCategories,
  }) {
    return CategoryOnboardingState(
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
