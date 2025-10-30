import 'meal_param.dart';

class MenuParam {
  String? name;
  String? description;
  int? imageId;
  int? restaurantId;
  List<MealParam>? meals;

  MenuParam({this.name, this.description, this.imageId, this.restaurantId, this.meals});

  @override
  String toString() {
    return 'MenuParam(name: $name, description: $description, imageId: $imageId, restaurantId: $restaurantId, meals: $meals)';
  }

  factory MenuParam.fromJson(Map<String, dynamic> json) => MenuParam(
    name: json['name'] as String?,
    description: json['description'] as String?,
    imageId: json['image_id'] as int?,
    restaurantId: json['restaurant_id'] as int?,
    meals:
        (json['meals'] as List<dynamic>?)
            ?.map((e) => MealParam.fromJson(e as Map<String, dynamic>))
            .toList(),
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'image_id': imageId,

    'restaurant_id': restaurantId,
    'meals': meals?.map((e) => e.toJson()).toList(),
  };

  MenuParam copyWith({
    String? name,
    String? description,
    int? imageId,
    int? restaurantId,
    List<MealParam>? meals,
  }) {
    return MenuParam(
      name: name ?? this.name,
      description: description ?? this.description,
      imageId: imageId ?? this.imageId,
      restaurantId: restaurantId ?? this.restaurantId,
      meals: meals ?? this.meals,
    );
  }
}
