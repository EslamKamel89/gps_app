import 'restaurant.dart';

class RestaurantMenu {
  int? id;
  int? restaurantId;
  String? name;
  String? description;
  int? imageId;
  Restaurant? restaurant;

  RestaurantMenu({
    this.id,
    this.restaurantId,
    this.name,
    this.description,
    this.imageId,
    this.restaurant,
  });

  @override
  String toString() {
    return 'RestaurantMenu(id: $id, restaurantId: $restaurantId, name: $name, description: $description, imageId: $imageId, restaurant: $restaurant)';
  }

  factory RestaurantMenu.fromJson(Map<String, dynamic> json) {
    return RestaurantMenu(
      id: json['id'] as int?,
      restaurantId: json['restaurant_id'] as int?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      imageId: json['image_id'] as int?,
      restaurant:
          json['restaurant'] == null
              ? null
              : Restaurant.fromJson(json['restaurant'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'restaurant_id': restaurantId,
    'name': name,
    'description': description,
    'image_id': imageId,
    'restaurant': restaurant?.toJson(),
  };

  RestaurantMenu copyWith({
    int? id,
    int? restaurantId,
    String? name,
    String? description,
    int? imageId,
    Restaurant? restaurant,
  }) {
    return RestaurantMenu(
      id: id ?? this.id,
      restaurantId: restaurantId ?? this.restaurantId,
      name: name ?? this.name,
      description: description ?? this.description,
      imageId: imageId ?? this.imageId,
      restaurant: restaurant ?? this.restaurant,
    );
  }
}
