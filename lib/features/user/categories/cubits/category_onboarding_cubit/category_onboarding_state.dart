// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'category_onboarding_cubit.dart';

class CategoryOnboardingState {
  ApiResponseModel<List<CategoryModel>> categories;
  List<CategoryModel> selectedCategories;
  List<SubCategoryModel> selectedSubCategories;
  CategoryOnboardingState({
    required this.categories,
    required this.selectedCategories,
    required this.selectedSubCategories,
  });
  factory CategoryOnboardingState.initial() {
    return CategoryOnboardingState(
      selectedCategories: [],
      selectedSubCategories: [],
      categories: ApiResponseModel(),
    );
  }

  CategoryOnboardingState copyWith({
    ApiResponseModel<List<CategoryModel>>? categories,
    List<CategoryModel>? selectedCategories,
    List<SubCategoryModel>? selectedSubCategories,
  }) {
    return CategoryOnboardingState(
      categories: categories ?? this.categories,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      selectedSubCategories:
          selectedSubCategories ?? this.selectedSubCategories,
    );
  }

  @override
  String toString() =>
      'CategoryState(categories: $categories, selectedCategories: $selectedCategories, selectedSubCategories: $selectedSubCategories)';
}
