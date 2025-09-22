class CatalogItemParam {
  String? name;
  double? price;
  String? description;
  int? position;
  int? imageId;

  CatalogItemParam({
    this.name,
    this.price,
    this.description,
    this.position,
    this.imageId,
  });

  @override
  String toString() {
    return 'CatalogItem(name: $name, price: $price, description: $description, position: $position, imageId: $imageId)';
  }

  factory CatalogItemParam.fromJson(Map<String, dynamic> json) =>
      CatalogItemParam(
        name: json['name'] as String?,
        price: json['price'] as double?,
        description: json['description'] as String?,
        position: json['position'] as int?,
        imageId: json['image_id'] as int?,
      );

  Map<String, dynamic> toJson() => {
    'name': name,
    'price': price,
    'description': description,
    'position': position,
    'image_id': imageId,
  };

  CatalogItemParam copyWith({
    String? name,
    double? price,
    String? description,
    int? position,
    int? imageId,
  }) {
    return CatalogItemParam(
      name: name ?? this.name,
      price: price ?? this.price,
      description: description ?? this.description,
      position: position ?? this.position,
      imageId: imageId ?? this.imageId,
    );
  }
}
