// ignore_for_file: public_member_api_docs, sort_constructors_first
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

  @override
  String toString() {
    return 'ItemModel(id: $id, userId: $userId, vendorId: $vendorId, farmId: $farmId, storeId: $storeId, catalogSectionId: $catalogSectionId, name: $name, description: $description, price: $price)';
  }
}
