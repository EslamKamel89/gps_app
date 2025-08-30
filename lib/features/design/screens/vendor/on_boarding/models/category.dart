class Category {
  String id;
  String menuName;
  String? description;
  Map<String, String> availabilityHours;
  List<ProductItem> items;

  Category({
    required this.id,
    required this.menuName,
    this.description,
    required this.availabilityHours,
    required this.items,
  });

  factory Category.empty() => Category(
    id: DateTime.now().millisecondsSinceEpoch.toString(),
    menuName: '',
    availabilityHours: {'Mon-Fri': '11:00 AM - 3:00 PM'},
    items: [ProductItem.empty()],
  );
}

class ProductItem {
  String id;
  String name;
  double price;
  String? description;
  String category;
  bool isSpicy;

  ProductItem({
    required this.id,
    required this.name,
    required this.price,
    this.description,
    required this.category,
    this.isSpicy = false,
  });

  factory ProductItem.empty() => ProductItem(
    id: DateTime.now().millisecondsSinceEpoch.toString(),
    name: '',
    price: 0.0,
    category: 'Mains',
    isSpicy: false,
  );

  ProductItem copyWith({
    String? name,
    double? price,
    String? description,
    String? category,
    bool? isSpicy,
  }) {
    return ProductItem(
      id: id,
      name: name ?? this.name,
      price: price ?? this.price,
      description: description ?? this.description,
      category: category ?? this.category,
      isSpicy: isSpicy ?? this.isSpicy,
    );
  }
}
