class CatalogItem {
  String? name;
  int? price;
  String? description;
  int? position;
  int? imageId;

  CatalogItem({
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

  factory CatalogItem.fromJson(Map<String, dynamic> json) => CatalogItem(
    name: json['name'] as String?,
    price: json['price'] as int?,
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

  CatalogItem copyWith({
    String? name,
    int? price,
    String? description,
    int? position,
    int? imageId,
  }) {
    return CatalogItem(
      name: name ?? this.name,
      price: price ?? this.price,
      description: description ?? this.description,
      position: position ?? this.position,
      imageId: imageId ?? this.imageId,
    );
  }
}
