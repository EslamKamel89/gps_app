class SubCategoryModel {
  int? id;
  String? name;
  int? categoryId;
  String? image;
  String? imageUrl;
  String? description;

  SubCategoryModel({
    this.id,
    this.name,
    this.categoryId,
    this.image,
    this.imageUrl,
    this.description,
  });

  @override
  String toString() {
    return 'SubCategory(id: $id, name: $name, categoryId: $categoryId, image: $image, imageUrl: $imageUrl , description: $description)';
  }

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) =>
      SubCategoryModel(
        id: json['id'] as int?,
        name: json['name'] as String?,
        categoryId: json['category_id'] as int?,
        image: json['image'] as String?,
        imageUrl: json['image_url'] as String?,
        description: json['description'] as String?,
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'category_id': categoryId,
    'image': image,
    'image_url': imageUrl,
    'description': description,
  };
}
