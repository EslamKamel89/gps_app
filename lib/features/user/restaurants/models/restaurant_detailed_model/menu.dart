import 'image.dart';
import 'meal.dart';

class Menu {
  int? id;
  int? restaurantId;
  String? name;
  String? description;
  int? imageId;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<Image>? images;
  List<Meal>? meals;

  Menu({
    this.id,
    this.restaurantId,
    this.name,
    this.description,
    this.imageId,
    this.createdAt,
    this.updatedAt,
    this.images,
    this.meals,
  });

  @override
  String toString() {
    return 'Menu(id: $id, restaurantId: $restaurantId, name: $name, description: $description, imageId: $imageId, createdAt: $createdAt, updatedAt: $updatedAt, images: $images, meals: $meals)';
  }

  factory Menu.fromJson(Map<String, dynamic> json) => Menu(
    id: json['id'] as int?,
    restaurantId: json['restaurant_id'] as int?,
    name: json['name'] as String?,
    description: json['description'] as String?,
    imageId: json['image_id'] as int?,
    createdAt:
        json['created_at'] == null
            ? null
            : DateTime.parse(json['created_at'] as String),
    updatedAt:
        json['updated_at'] == null
            ? null
            : DateTime.parse(json['updated_at'] as String),
    images:
        (json['images'] as List<dynamic>?)
            ?.map((e) => Image.fromJson(e as Map<String, dynamic>))
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
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
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
    List<Image>? images,
    List<Meal>? meals,
  }) {
    return Menu(
      id: id ?? this.id,
      restaurantId: restaurantId ?? this.restaurantId,
      name: name ?? this.name,
      description: description ?? this.description,
      imageId: imageId ?? this.imageId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      images: images ?? this.images,
      meals: meals ?? this.meals,
    );
  }
}
