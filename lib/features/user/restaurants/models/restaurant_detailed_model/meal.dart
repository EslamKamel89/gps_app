import 'package:gps_app/features/user/restaurants/models/restaurant_detailed_model/export.dart';

class Meal {
  String? name;
  String? description;
  String? price;
  List<RestaurantImage>? images;
  Category? categories;
  Category? subcategories;

  Meal({
    this.name,
    this.description,
    this.price,
    this.images,
    this.categories,
    this.subcategories,
  });

  @override
  String toString() {
    return 'Meal(name: $name, description: $description, price: $price , image: $images , categories: $categories , subcategories: $subcategories)';
  }

  factory Meal.fromJson(Map<String, dynamic> json) => Meal(
    name: json['name'] as String?,
    description: json['description'] as String?,
    price: json['price'] as String?,
    images:
        (json['images'] as List<dynamic>?)
            ?.map((e) => RestaurantImage.fromJson(e as Map<String, dynamic>))
            .toList(),
    categories:
        json['categories'] == null
            ? null
            : Category.fromJson(json['categories'] as Map<String, dynamic>),
    subcategories:
        json['subcategories'] == null
            ? null
            : Category.fromJson(json['subcategories'] as Map<String, dynamic>),
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'price': price,
    'images': images?.map((e) => e.toJson()).toList(),
    'categories': categories?.toJson(),
    'subcategories': subcategories?.toJson(),
  };

  Meal copyWith({
    String? name,
    String? description,
    String? price,
    List<RestaurantImage>? images,
    Category? categories,
    Category? subcategories,
  }) {
    return Meal(
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      images: images ?? this.images,
      categories: categories ?? this.categories,
      subcategories: subcategories ?? this.subcategories,
    );
  }
}
