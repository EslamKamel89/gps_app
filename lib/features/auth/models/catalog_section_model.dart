import 'package:gps_app/features/auth/models/image_model.dart';

import 'catalog_item_model.dart';

class CatalogSectionModel {
  int? userId;
  int? vendorId;
  String? name;
  int? position;
  DateTime? updatedAt;
  DateTime? createdAt;
  int? id;
  ImageModel? image;
  List<CatalogItemModel>? items;

  CatalogSectionModel({
    this.userId,
    this.vendorId,
    this.name,
    this.position,
    this.updatedAt,
    this.createdAt,
    this.id,
    this.image,
    this.items,
  });

  @override
  String toString() {
    return 'CatalogSectionModel(userId: $userId, vendorId: $vendorId, name: $name, position: $position, updatedAt: $updatedAt, createdAt: $createdAt, id: $id, image: $image, items: $items)';
  }

  factory CatalogSectionModel.fromJson(Map<String, dynamic> json) {
    return CatalogSectionModel(
      userId: json['user_id'] as int?,
      vendorId: json['vendor_id'] as int?,
      name: json['name'] as String?,
      position: json['position'] as int?,
      updatedAt:
          json['updated_at'] == null
              ? null
              : DateTime.parse(json['updated_at'] as String),
      createdAt:
          json['created_at'] == null
              ? null
              : DateTime.parse(json['created_at'] as String),
      id: json['id'] as int?,
      image:
          json['image'] == null
              ? null
              : ImageModel.fromJson(json['image'] as Map<String, dynamic>),
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => CatalogItemModel.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'vendor_id': vendorId,
    'name': name,
    'position': position,
    'updated_at': updatedAt?.toIso8601String(),
    'created_at': createdAt?.toIso8601String(),
    'id': id,
    'image': image?.toJson(),
    'items': items?.map((e) => e.toJson()).toList(),
  };

  CatalogSectionModel copyWith({
    int? userId,
    int? vendorId,
    String? name,
    int? position,
    DateTime? updatedAt,
    DateTime? createdAt,
    int? id,
    ImageModel? image,
    List<CatalogItemModel>? items,
  }) {
    return CatalogSectionModel(
      userId: userId ?? this.userId,
      vendorId: vendorId ?? this.vendorId,
      name: name ?? this.name,
      position: position ?? this.position,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
      id: id ?? this.id,
      image: image ?? this.image,
      items: items ?? this.items,
    );
  }
}
