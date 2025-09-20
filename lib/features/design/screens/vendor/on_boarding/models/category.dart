class CategoryEntity {
  String id;
  String menuName;
  String? description;
  Map<String, String> availabilityHours;
  List<ProductEntity> items;

  CategoryEntity({
    required this.id,
    required this.menuName,
    this.description,
    required this.availabilityHours,
    required this.items,
  });

  factory CategoryEntity.empty() => CategoryEntity(
    id: DateTime.now().millisecondsSinceEpoch.toString(),
    menuName: '',
    availabilityHours: {'Mon-Fri': '11:00 AM - 3:00 PM'},
    items: [ProductEntity.empty()],
  );
}

class ProductEntity {
  String id;
  String name;
  double price;
  String? description;
  String category;
  bool isSpicy;

  ProductEntity({
    required this.id,
    required this.name,
    required this.price,
    this.description,
    required this.category,
    this.isSpicy = false,
  });

  factory ProductEntity.empty() => ProductEntity(
    id: DateTime.now().millisecondsSinceEpoch.toString(),
    name: '',
    price: 0.0,
    category: 'Mains',
    isSpicy: false,
  );

  ProductEntity copyWith({
    String? name,
    double? price,
    String? description,
    String? category,
    bool? isSpicy,
  }) {
    return ProductEntity(
      id: id,
      name: name ?? this.name,
      price: price ?? this.price,
      description: description ?? this.description,
      category: category ?? this.category,
      isSpicy: isSpicy ?? this.isSpicy,
    );
  }
}
