import 'package:gps_app/features/user/restaurants/models/restaurant_detailed_model/import.dart';

class Meal {
  String? name;
  String? description;
  String? price;
  List<RestaurantImage>? images;

  Meal({this.name, this.description, this.price, this.images});

  @override
  String toString() {
    return 'Meal(name: $name, description: $description, price: $price , image: $images)';
  }

  factory Meal.fromJson(Map<String, dynamic> json) => Meal(
    name: json['name'] as String?,
    description: json['description'] as String?,
    price: json['price'] as String?,
    images:
        (json['images'] as List<dynamic>?)
            ?.map((e) => RestaurantImage.fromJson(e as Map<String, dynamic>))
            .toList(),
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'price': price,
    'images': images?.map((e) => e.toJson()).toList(),
  };

  Meal copyWith({String? name, String? description, String? price, List<RestaurantImage>? images}) {
    return Meal(
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      images: images ?? this.images,
    );
  }
}
