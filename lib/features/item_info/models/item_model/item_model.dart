import 'images.dart';
import 'section.dart';
import 'store.dart';

class ItemModel {
  int? id;
  int? userId;
  int? vendorId;
  dynamic farmId;
  int? storeId;
  int? catalogSectionId;
  String? name;
  String? price;
  String? description;
  bool? status;
  int? position;
  Store? store;
  dynamic farm;
  Section? section;
  Images? images;

  ItemModel({
    this.id,
    this.userId,
    this.vendorId,
    this.farmId,
    this.storeId,
    this.catalogSectionId,
    this.name,
    this.price,
    this.description,
    this.status,
    this.position,
    this.store,
    this.farm,
    this.section,
    this.images,
  });

  @override
  String toString() {
    return 'ItemModel(id: $id, userId: $userId, vendorId: $vendorId, farmId: $farmId, storeId: $storeId, catalogSectionId: $catalogSectionId, name: $name, price: $price, description: $description, status: $status, position: $position, store: $store, farm: $farm, section: $section, images: $images)';
  }

  factory ItemModel.fromJson(Map<String, dynamic> json) => ItemModel(
    id: json['id'] as int?,
    userId: json['user_id'] as int?,
    vendorId: json['vendor_id'] as int?,
    farmId: json['farm_id'] as dynamic,
    storeId: json['store_id'] as int?,
    catalogSectionId: json['catalog_section_id'] as int?,
    name: json['name'] as String?,
    price: json['price'] as String?,
    description: json['description'] as String?,
    status: json['status'] as bool?,
    position: json['position'] as int?,
    store:
        json['store'] == null
            ? null
            : Store.fromJson(json['store'] as Map<String, dynamic>),
    farm: json['farm'] as dynamic,
    section:
        json['section'] == null
            ? null
            : Section.fromJson(json['section'] as Map<String, dynamic>),
    images:
        json['images'] == null
            ? null
            : Images.fromJson(json['images'] as Map<String, dynamic>),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'vendor_id': vendorId,
    'farm_id': farmId,
    'store_id': storeId,
    'catalog_section_id': catalogSectionId,
    'name': name,
    'price': price,
    'description': description,
    'status': status,
    'position': position,
    'store': store?.toJson(),
    'farm': farm,
    'section': section?.toJson(),
    'images': images?.toJson(),
  };

  ItemModel copyWith({
    int? id,
    int? userId,
    int? vendorId,
    dynamic farmId,
    int? storeId,
    int? catalogSectionId,
    String? name,
    String? price,
    String? description,
    bool? status,
    int? position,
    Store? store,
    dynamic farm,
    Section? section,
    Images? images,
  }) {
    return ItemModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      vendorId: vendorId ?? this.vendorId,
      farmId: farmId ?? this.farmId,
      storeId: storeId ?? this.storeId,
      catalogSectionId: catalogSectionId ?? this.catalogSectionId,
      name: name ?? this.name,
      price: price ?? this.price,
      description: description ?? this.description,
      status: status ?? this.status,
      position: position ?? this.position,
      store: store ?? this.store,
      farm: farm ?? this.farm,
      section: section ?? this.section,
      images: images ?? this.images,
    );
  }
}
