import 'package:gps_app/features/auth/models/image_model.dart';

class CatalogItemModel {
  int? id;
  int? userId;
  int? vendorId;
  int? catalogSectionId;
  String? name;
  String? price;
  String? description;
  bool? status;
  int? position;
  DateTime? createdAt;
  DateTime? updatedAt;
  ImageModel? image;

  CatalogItemModel({
    this.id,
    this.userId,
    this.vendorId,
    this.catalogSectionId,
    this.name,
    this.price,
    this.description,
    this.status,
    this.position,
    this.createdAt,
    this.updatedAt,
    this.image,
  });

  @override
  String toString() {
    return 'Item(id: $id, userId: $userId, vendorId: $vendorId, catalogSectionId: $catalogSectionId, name: $name, price: $price, description: $description, status: $status, position: $position, createdAt: $createdAt, updatedAt: $updatedAt, image: $image)';
  }

  factory CatalogItemModel.fromJson(Map<String, dynamic> json) => CatalogItemModel(
    id: json['id'] as int?,
    userId: json['user_id'] as int?,
    vendorId: json['vendor_id'] as int?,
    catalogSectionId: json['catalog_section_id'] as int?,
    name: json['name'] as String?,
    price: json['price'] as String?,
    description: json['description'] as String?,
    status: json['status'] as bool?,
    position: json['position'] as int?,
    createdAt: json['created_at'] == null ? null : DateTime.parse(json['created_at'] as String),
    updatedAt: json['updated_at'] == null ? null : DateTime.parse(json['updated_at'] as String),
    image:
        json['image'] == null ? null : ImageModel.fromJson(json['image'] as Map<String, dynamic>),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'vendor_id': vendorId,
    'catalog_section_id': catalogSectionId,
    'name': name,
    'price': price,
    'description': description,
    'status': status,
    'position': position,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
    'image': image?.toJson(),
  };

  CatalogItemModel copyWith({
    int? id,
    int? userId,
    int? vendorId,
    int? catalogSectionId,
    String? name,
    String? price,
    String? description,
    bool? status,
    int? position,
    DateTime? createdAt,
    DateTime? updatedAt,
    ImageModel? image,
  }) {
    return CatalogItemModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      vendorId: vendorId ?? this.vendorId,
      catalogSectionId: catalogSectionId ?? this.catalogSectionId,
      name: name ?? this.name,
      price: price ?? this.price,
      description: description ?? this.description,
      status: status ?? this.status,
      position: position ?? this.position,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      image: image ?? this.image,
    );
  }
}
