import 'image.dart';
import 'meal.dart';

class Menu {
  int? id;
  int? restaurantId;
  String? name;
  String? description;
  int? imageId;
  List<RestaurantImage>? images;
  List<Meal>? meals;

  Menu({
    this.id,
    this.restaurantId,
    this.name,
    this.description,
    this.imageId,
    this.images,
    this.meals,
  });

  @override
  String toString() {
    return 'Menu(id: $id, restaurantId: $restaurantId, name: $name, description: $description, imageId: $imageId, images: $images, meals: $meals)';
  }

  factory Menu.fromJson(Map<String, dynamic> json) => Menu(
    id: json['id'] as int?,
    restaurantId: json['restaurant_id'] as int?,
    name: json['name'] as String?,
    description: json['description'] as String?,
    imageId: json['image_id'] as int?,
    images:
        (json['images'] as List<dynamic>?)
            ?.map((e) => RestaurantImage.fromJson(e as Map<String, dynamic>))
            .toList(),
    meals:
        (json['meals'] as List<dynamic>?)
            ?.map((e) => Meal.fromJson(e as Map<String, dynamic>))
            .toList(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'restaurant_id': restaurantId,
    'name': name,
    'description': description,
    'image_id': imageId,
    'images': images?.map((e) => e.toJson()).toList(),
    'meals': meals?.map((e) => e.toJson()).toList(),
  };

  Menu copyWith({
    int? id,
    int? restaurantId,
    String? name,
    String? description,
    int? imageId,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<RestaurantImage>? images,
    List<Meal>? meals,
  }) {
    return Menu(
      id: id ?? this.id,
      restaurantId: restaurantId ?? this.restaurantId,
      name: name ?? this.name,
      description: description ?? this.description,
      imageId: imageId ?? this.imageId,
      images: images ?? this.images,
      meals: meals ?? this.meals,
    );
  }
}
