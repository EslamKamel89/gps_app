class ItemModel {
  final int? id;
  final int? userId;
  final int? vendorId;
  final int? farmId;
  final int? storeId;
  final int? catalogSectionId;
  final String? name;
  final String? description;
  final String? price;

  const ItemModel({
    this.id,
    this.name,
    this.description,
    this.price,
    this.userId,
    this.vendorId,
    this.farmId,
    this.storeId,
    this.catalogSectionId,
  });
  factory ItemModel.fromJson(Map<String, dynamic> json) => ItemModel(
    id: json['id'] as int?,
    userId: json['user_id'] as int?,
    vendorId: json['vendor_id'] as int?,
    farmId: json['farm_id'] as int?,
    storeId: json['store_id'] as int?,
    catalogSectionId: json['catalog_section_id'] as int?,
    name: json['name'] as String?,
    price: json['price'] as String?,
    description: json['description'] as String?,
  );
}
