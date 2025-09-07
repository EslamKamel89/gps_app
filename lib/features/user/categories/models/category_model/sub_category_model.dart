class SubCategoryModel {
  int? id;
  String? name;
  int? categoryId;
  String? image;
  String? imageUrl;

  SubCategoryModel({this.id, this.name, this.categoryId, this.image, this.imageUrl});

  @override
  String toString() {
    return 'SubCategory(id: $id, name: $name, categoryId: $categoryId, image: $image, imageUrl: $imageUrl)';
  }

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) => SubCategoryModel(
    id: json['id'] as int?,
    name: json['name'] as String?,
    categoryId: json['category_id'] as int?,
    image: json['image'] as String?,
    imageUrl: json['image_url'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'category_id': categoryId,
    'image': image,
    'image_url': imageUrl,
  };
}
