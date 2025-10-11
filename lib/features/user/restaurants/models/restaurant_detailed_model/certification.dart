import 'file.dart';

class Certification {
  int? id;
  String? title;
  String? description;
  int? restaurantId;
  List<RestaurantFile>? file;

  Certification({this.id, this.title, this.description, this.restaurantId, this.file});

  @override
  String toString() {
    return 'Certification(id: $id, title: $title, description: $description, restaurantId: $restaurantId, file: $file)';
  }

  factory Certification.fromJson(Map<String, dynamic> json) => Certification(
    id: json['id'] as int?,
    title: json['title'] as String?,
    description: json['description'] as String?,
    restaurantId: json['restaurant_id'] as int?,
    file:
        (json['file'] as List<dynamic>?)
            ?.map((e) => RestaurantFile.fromJson(e as Map<String, dynamic>))
            .toList(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'restaurant_id': restaurantId,
    'file': file?.map((e) => e.toJson()).toList(),
  };

  Certification copyWith({
    int? id,
    String? title,
    String? description,
    int? restaurantId,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<RestaurantFile>? file,
  }) {
    return Certification(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      restaurantId: restaurantId ?? this.restaurantId,
      file: file ?? this.file,
    );
  }
}
