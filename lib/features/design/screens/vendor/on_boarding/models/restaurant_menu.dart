class RestaurantMenu {
  String id;
  String menuName;
  String? description;
  Map<String, String> availabilityHours;
  List<MenuItem> items;

  RestaurantMenu({
    required this.id,
    required this.menuName,
    this.description,
    required this.availabilityHours,
    required this.items,
  });

  factory RestaurantMenu.empty() => RestaurantMenu(
    id: DateTime.now().millisecondsSinceEpoch.toString(),
    menuName: '',
    availabilityHours: {'Mon-Fri': '11:00 AM - 3:00 PM'},
    items: [MenuItem.empty()],
  );
}

class MenuItem {
  String id;
  String name;
  double price;
  String? description;
  String category;
  bool isSpicy;

  MenuItem({
    required this.id,
    required this.name,
    required this.price,
    this.description,
    required this.category,
    this.isSpicy = false,
  });

  factory MenuItem.empty() => MenuItem(
    id: DateTime.now().millisecondsSinceEpoch.toString(),
    name: '',
    price: 0.0,
    category: 'Mains',
    isSpicy: false,
  );

  MenuItem copyWith({
    String? name,
    double? price,
    String? description,
    String? category,
    bool? isSpicy,
  }) {
    return MenuItem(
      id: id,
      name: name ?? this.name,
      price: price ?? this.price,
      description: description ?? this.description,
      category: category ?? this.category,
      isSpicy: isSpicy ?? this.isSpicy,
    );
  }
}
