import 'package:gps_app/features/auth/models/image_model.dart';

import 'sub_category_model.dart';

class CategoryModel {
  int? id;
  String? name;
  String? description;
  ImageModel? image;
  List<SubCategoryModel>? subCategories;

  CategoryModel({this.id, this.name, this.description, this.image, this.subCategories});

  @override
  String toString() {
    return 'CategoryModel(id: $id, name: $name, description: $description image: $image, subCategories: $subCategories)';
  }

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    id: json['id'] as int?,
    name: json['name'] as String?,
    description: json['description'] as String?,
    image: json['image'] == null ? null : ImageModel.fromJson(json['image']),
    subCategories:
        (json['sub_categories'] as List<dynamic>?)
            ?.map((e) => SubCategoryModel.fromJson(e as Map<String, dynamic>))
            .toList(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'image': image?.toJson(),
    'sub_categories': subCategories?.map((e) => e.toJson()).toList(),
  };
}
