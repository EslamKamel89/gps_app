class Meal {
  String? name;
  String? description;
  String? price;

  Meal({this.name, this.description, this.price});

  @override
  String toString() {
    return 'Meal(name: $name, description: $description, price: $price)';
  }

  factory Meal.fromJson(Map<String, dynamic> json) => Meal(
    name: json['name'] as String?,
    description: json['description'] as String?,
    price: json['price'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'price': price,
  };

  Meal copyWith({String? name, String? description, String? price}) {
    return Meal(
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
    );
  }
}
