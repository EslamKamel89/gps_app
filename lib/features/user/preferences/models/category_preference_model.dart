// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:gps_app/core/helpers/unique_object_in_array.dart';
import 'package:gps_app/features/user/preferences/models/category_model/category_model.dart';
import 'package:gps_app/features/user/preferences/models/category_model/sub_category_model.dart';

class CategoryPreferenceModel {
  int? id;
  CategoryModel? category;
  SubCategoryModel? subCategory;
  CategoryPreferenceModel({this.id, this.category, this.subCategory});

  factory CategoryPreferenceModel.fromJson(Map<String, dynamic> json) => CategoryPreferenceModel(
    id: json['id'] as int?,
    subCategory:
        json['sub_category'] == null ? null : SubCategoryModel.fromJson(json['sub_category']),
    category:
        json['sub_category'] != null && json['sub_category']['category'] != null
            ? CategoryModel.fromJson(json['sub_category']['category'])
            : null,
  );
  @override
  String toString() =>
      'CategoryPreferenceModel(id: $id, category: $category, subCategory: $subCategory)';
}

class SelectedCategoriesPreferences {
  List<CategoryModel> categories = [];
  List<SubCategoryModel> subCategories = [];
  SelectedCategoriesPreferences({required this.categories, required this.subCategories});
  factory SelectedCategoriesPreferences.fromResponse(List<CategoryPreferenceModel> prefs) {
    return SelectedCategoriesPreferences(
      categories: getUniqueListByProperty<CategoryModel, int?>(
        prefs.map((p) => p.category!).toList(),
        (c) => c.id,
      ),
      subCategories: getUniqueListByProperty<SubCategoryModel, int?>(
        prefs.map((p) => p.subCategory!).toList(),
        (s) => s.id,
      ),
    );
  }
  // factory SelectedCategoriesPreferences.fromResponse(List<CategoryPreferenceModel> prefs) {
  //   return SelectedCategoriesPreferences(
  //     categories: prefs.map((p) => p.category!).toList(),
  //     subCategories: prefs.map((p) => p.subCategory!).toList(),
  //   );
  // }

  @override
  String toString() =>
      'SelectedCategoriesPreferences(categories: $categories, subCategories: $subCategories)';
}
