import 'package:gps_app/features/auth/models/image_model.dart';

class DietModel {
  int? id;
  String? name;
  String? description;
  ImageModel? image;

  DietModel({this.id, this.name, this.description, this.image});

  @override
  String toString() {
    return 'DietModel(id: $id, name: $name, description: $description, image: $image)';
  }

  factory DietModel.fromJson(Map<String, dynamic> json) => DietModel(
    id: json['id'] as int?,
    name: json['name'] as String?,
    description: json['description'] as String?,
    image: json['image'] == null ? null : ImageModel.fromJson(json['image']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'image': image?.toJson(),
  };
}
