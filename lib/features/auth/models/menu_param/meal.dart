class MealParam {
  String? name;
  String? description;
  int? price;
  int? imageId;
  int? categoryId;
  int? subCategoryId;

  MealParam({
    this.name,
    this.description,
    this.price,
    this.imageId,
    this.categoryId,
    this.subCategoryId,
  });

  @override
  String toString() {
    return 'Meal(name: $name, description: $description, price: $price, imageId: $imageId, categoryId: $categoryId, subCategoryId: $subCategoryId)';
  }

  factory MealParam.fromJson(Map<String, dynamic> json) => MealParam(
    name: json['name'] as String?,
    description: json['description'] as String?,
    price: json['price'] as int?,
    imageId: json['image_id'] as int?,
    categoryId: json['category_id'] as int?,
    subCategoryId: json['sub_category_id'] as int?,
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'price': price,
    'image_id': imageId,
    'category_id': categoryId,
    'sub_category_id': subCategoryId,
  };

  MealParam copyWith({
    String? name,
    String? description,
    int? price,
    int? imageId,
    int? categoryId,
    int? subCategoryId,
  }) {
    return MealParam(
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageId: imageId ?? this.imageId,
      categoryId: categoryId ?? this.categoryId,
      subCategoryId: subCategoryId ?? this.subCategoryId,
    );
  }
}
