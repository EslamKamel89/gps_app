import 'package:gps_app/features/user/restaurant_details/models/restaurant_detailed_model/export.dart';

class Meal {
  int? id;
  String? name;
  String? description;
  String? price;
  RestaurantImage? images;
  Category? categories;
  Category? subcategories;

  Meal({
    this.id,
    this.name,
    this.description,
    this.price,
    this.images,
    this.categories,
    this.subcategories,
  });

  @override
  String toString() {
    return 'Meal(id: $id ,name: $name, description: $description, price: $price , image: $images , categories: $categories , subcategories: $subcategories)';
  }

  factory Meal.fromJson(Map<String, dynamic> json) => Meal(
    id: json['id'] as int?,
    name: json['name'] as String?,
    description: json['description'] as String?,
    price: json['price'] as String?,
    // images:
    //     (json['images'] as List<dynamic>?)
    //         ?.map((e) => RestaurantImage.fromJson(e as Map<String, dynamic>))
    //         .toList(),
    images:
        json['images'] == null
            ? null
            : RestaurantImage.fromJson(json['images'] as Map<String, dynamic>),
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
    'id': id,
    'name': name,
    'description': description,
    'price': price,
    // 'images': images?.map((e) => e.toJson()).toList(),
    'images': images?.toJson(),
    'categories': categories?.toJson(),
    'subcategories': subcategories?.toJson(),
  };

  Meal copyWith({
    int? id,
    String? name,
    String? description,
    String? price,
    RestaurantImage? images,
    Category? categories,
    Category? subcategories,
  }) {
    return Meal(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      images: images ?? this.images,
      categories: categories ?? this.categories,
      subcategories: subcategories ?? this.subcategories,
    );
  }
}
