import 'file.dart';

class Certification {
  int? id;
  String? title;
  String? description;
  int? restaurantId;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<RestaurantFile>? file;

  Certification({
    this.id,
    this.title,
    this.description,
    this.restaurantId,
    this.createdAt,
    this.updatedAt,
    this.file,
  });

  @override
  String toString() {
    return 'Certification(id: $id, title: $title, description: $description, restaurantId: $restaurantId, createdAt: $createdAt, updatedAt: $updatedAt, file: $file)';
  }

  factory Certification.fromJson(Map<String, dynamic> json) => Certification(
    id: json['id'] as int?,
    title: json['title'] as String?,
    description: json['description'] as String?,
    restaurantId: json['restaurant_id'] as int?,
    createdAt: json['created_at'] == null ? null : DateTime.parse(json['created_at'] as String),
    updatedAt: json['updated_at'] == null ? null : DateTime.parse(json['updated_at'] as String),
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
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
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
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      file: file ?? this.file,
    );
  }
}
