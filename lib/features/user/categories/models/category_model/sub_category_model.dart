import 'package:gps_app/features/auth/models/image_model.dart';

class SubCategoryModel {
  int? id;
  String? name;
  int? categoryId;
  ImageModel? image;
  String? description;

  SubCategoryModel({this.id, this.name, this.categoryId, this.image, this.description});

  @override
  String toString() {
    return 'SubCategory(id: $id, name: $name, categoryId: $categoryId, image: $image, description: $description)';
  }

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) => SubCategoryModel(
    id: json['id'] as int?,
    name: json['name'] as String?,
    categoryId: json['category_id'] as int?,
    image: json['image'] == null ? null : ImageModel.fromJson(json['image']),
    description: json['description'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'category_id': categoryId,
    'image': image?.toJson(),
    'description': description,
  };
}
