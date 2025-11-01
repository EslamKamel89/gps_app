// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:gps_app/features/item_info/models/item_model/item_model.dart';
import 'package:gps_app/features/item_info/models/meal_model/meal_model.dart';

class ItemInfoModel {
  MealModel? meal;
  ItemModel? item;
  ItemInfoModel({this.meal, this.item});
  factory ItemInfoModel.fromJson(Map<String, dynamic> json) {
    if (json['catalog_section_id'] != null) {
      return ItemInfoModel(item: ItemModel.fromJson(json));
    }
    if (json['restaurant_menu_id'] != null) {
      return ItemInfoModel(meal: MealModel.fromJson(json));
    }
    return ItemInfoModel();
  }
  ItemInfoEntity toEntity() {
    final entity = ItemInfoEntity();
    if (item != null) {
      entity.itemImagePath = item?.images?.path;
      entity.isMeal = false;
      entity.name = item?.name;
      entity.description = item?.description;
      entity.sectionName = item?.section?.name;
    }
    if (meal != null) {
      if (meal?.image?.isNotEmpty == true) {
        entity.itemImagePath = meal?.image?[0].path;
      }
      entity.isMeal = true;
      entity.name = meal?.name;
      entity.description = meal?.description;
      entity.sectionName = meal?.restaurantMenu?.name;
    }
    return entity;
  }
}

class ItemInfoEntity {
  String? itemImagePath;
  bool? isMeal;
  String? name;
  String? description;
  String? sectionName;
  ItemInfoEntity({
    this.itemImagePath,
    this.isMeal,
    this.name,
    this.description,
    this.sectionName,
  });

  @override
  String toString() {
    return 'ItemInfoEntity(itemImagePath: $itemImagePath, isMeal: $isMeal, name: $name, description: $description, sectionName: $sectionName)';
  }
}
