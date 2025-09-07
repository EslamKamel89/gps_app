// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'category_cubit.dart';

class CategoryState {
  ApiResponseModel<List<CategoryModel>> categories;
  List<CategoryModel> selectedCategories;
  List<SubCategoryModel> selectedSubCategories;
  CategoryState({
    required this.categories,
    required this.selectedCategories,
    required this.selectedSubCategories,
  });
  factory CategoryState.initial() {
    return CategoryState(
      selectedCategories: [],
      selectedSubCategories: [],
      categories: ApiResponseModel(),
    );
  }

  CategoryState copyWith({
    ApiResponseModel<List<CategoryModel>>? categories,
    List<CategoryModel>? selectedCategories,
    List<SubCategoryModel>? selectedSubCategories,
  }) {
    return CategoryState(
      categories: categories ?? this.categories,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      selectedSubCategories: selectedSubCategories ?? this.selectedSubCategories,
    );
  }

  @override
  String toString() =>
      'CategoryState(categories: $categories, selectedCategories: $selectedCategories, selectedSubCategories: $selectedSubCategories)';
}
