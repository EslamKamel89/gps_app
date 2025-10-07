// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'category_selector_cubit.dart';

class CategorySelectorState {
  ApiResponseModel<List<CategoryModel>> categories;
  CategoryModel? selectedCategory;
  SubCategoryModel? selectedSubCategory;
  CategorySelectorState({
    required this.categories,
    this.selectedCategory,
    this.selectedSubCategory,
  });

  @override
  String toString() =>
      'CategoryOnboardingState(categories: $categories, selectedCategory: $selectedCategory, selectedSubCategory: $selectedSubCategory)';

  CategorySelectorState copyWith({
    ApiResponseModel<List<CategoryModel>>? categories,
    CategoryModel? selectedCategory,
    SubCategoryModel? selectedSubCategory,
  }) {
    return CategorySelectorState(
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedSubCategory: selectedSubCategory ?? this.selectedSubCategory,
    );
  }

  factory CategorySelectorState.initial() {
    return CategorySelectorState(categories: ApiResponseModel());
  }
}
