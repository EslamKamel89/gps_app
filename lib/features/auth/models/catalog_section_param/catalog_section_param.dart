import 'catalog_item.dart';

class CatalogSectionParam {
  String? name;
  int? position;
  int? imageId;
  List<CatalogItemParam>? catalogItems;

  CatalogSectionParam({this.name, this.position, this.imageId, this.catalogItems});

  @override
  String toString() {
    return 'CatalogSectionParam(name: $name, position: $position, imageId: $imageId, catalogItems: $catalogItems)';
  }

  factory CatalogSectionParam.fromJson(Map<String, dynamic> json) {
    return CatalogSectionParam(
      name: json['name'] as String?,
      position: json['position'] as int?,
      imageId: json['image_id'] as int?,
      catalogItems:
          (json['catalog_items'] as List<dynamic>?)
              ?.map((e) => CatalogItemParam.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'position': position,
    'image_id': imageId,
    'catalog_items': catalogItems?.map((e) => e.toJson()).toList(),
  };

  CatalogSectionParam copyWith({
    String? name,
    int? position,
    int? imageId,
    List<CatalogItemParam>? catalogItems,
  }) {
    return CatalogSectionParam(
      name: name ?? this.name,
      position: position ?? this.position,
      imageId: imageId ?? this.imageId,
      catalogItems: catalogItems ?? this.catalogItems,
    );
  }
}
