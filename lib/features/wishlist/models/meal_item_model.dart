import 'package:gps_app/features/auth/models/image_model.dart';

class MealItemModel {
  int? id;
  String? name;
  String? description;
  String? price;
  ImageModel? images;

  MealItemModel({this.id, this.name, this.description, this.price, this.images});

  @override
  String toString() {
    return 'MealItemModel(id: $id, name: $name, description: $description, price: $price , images: $images)';
  }

  factory MealItemModel.fromJson(Map<String, dynamic> json) => MealItemModel(
    id: json['id'] as int?,
    name: json['name'] as String?,
    description: json['description'] as String?,
    price: json['price'] as String?,
    images:
        json['images'] == null ? null : ImageModel.fromJson(json['images'] as Map<String, dynamic>),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'price': price,
    'images': images?.toJson(),
  };
}
