import 'sub_category_model.dart';

class CategoryModel {
  int? id;
  String? name;
  String? description;
  String? image;
  String? imageUrl;
  List<SubCategoryModel>? subCategories;

  CategoryModel({
    this.id,
    this.name,
    this.description,
    this.image,
    this.imageUrl,
    this.subCategories,
  });

  @override
  String toString() {
    return 'CategoryModel(id: $id, name: $name, description: $description image: $image, imageUrl: $imageUrl, subCategories: $subCategories)';
  }

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    id: json['id'] as int?,
    name: json['name'] as String?,
    description: json['description'] as String?,
    image: json['image'] as String?,
    imageUrl: json['image_url'] as String?,
    subCategories:
        (json['sub_categories'] as List<dynamic>?)
            ?.map((e) => SubCategoryModel.fromJson(e as Map<String, dynamic>))
            .toList(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'image': image,
    'image_url': imageUrl,
    'sub_categories': subCategories?.map((e) => e.toJson()).toList(),
  };
}
