import 'package:gps_app/features/auth/models/image_model.dart';
import 'package:gps_app/features/user/preferences/models/category_model/category_model.dart';
import 'package:gps_app/features/user/preferences/models/category_model/sub_category_model.dart';

import 'restaurant_menu.dart';

class MealModel {
  int? id;
  String? name;
  String? description;
  String? price;
  int? restaurantMenuId;
  int? imageId;
  int? categoryId;
  int? subCategoryId;
  CategoryModel? category;
  SubCategoryModel? subcategory;
  List<ImageModel>? image;
  RestaurantMenu? restaurantMenu;

  MealModel({
    this.id,
    this.name,
    this.description,
    this.price,
    this.restaurantMenuId,
    this.imageId,
    this.categoryId,
    this.subCategoryId,
    this.category,
    this.subcategory,
    this.image,
    this.restaurantMenu,
  });

  @override
  String toString() {
    return 'MealModel(id: $id, name: $name, description: $description, price: $price, restaurantMenuId: $restaurantMenuId, imageId: $imageId, categoryId: $categoryId, subCategoryId: $subCategoryId, category: $category, subcategory: $subcategory, image: $image, restaurantMenu: $restaurantMenu)';
  }

  factory MealModel.fromJson(Map<String, dynamic> json) => MealModel(
    id: json['id'] as int?,
    name: json['name'] as String?,
    description: json['description'] as String?,
    price: json['price'] as String?,
    restaurantMenuId: json['restaurant_menu_id'] as int?,
    imageId: json['image_id'] as int?,
    categoryId: json['category_id'] as int?,
    subCategoryId: json['sub_category_id'] as int?,
    category:
        json['category'] == null
            ? null
            : CategoryModel.fromJson(json['category'] as Map<String, dynamic>),
    subcategory:
        json['subcategory'] == null
            ? null
            : SubCategoryModel.fromJson(
              json['subcategory'] as Map<String, dynamic>,
            ),
    image:
        json['image'] == null
            ? null
            : json['image'] is List
            ? (json['image'] as List<dynamic>?)
                ?.map((e) => ImageModel.fromJson(e as Map<String, dynamic>))
                .toList()
            : [ImageModel.fromJson(json['image'])],
    restaurantMenu:
        json['restaurant_menu'] == null
            ? null
            : RestaurantMenu.fromJson(
              json['restaurant_menu'] as Map<String, dynamic>,
            ),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'price': price,
    'restaurant_menu_id': restaurantMenuId,
    'image_id': imageId,
    'category_id': categoryId,
    'sub_category_id': subCategoryId,
    'category': category?.toJson(),
    'subcategory': subcategory?.toJson(),
    'image': image?.map((e) => e.toJson()).toList(),
    'restaurant_menu': restaurantMenu?.toJson(),
  };

  MealModel copyWith({
    int? id,
    String? name,
    String? description,
    String? price,
    int? restaurantMenuId,
    int? imageId,
    int? categoryId,
    int? subCategoryId,
    CategoryModel? category,
    SubCategoryModel? subcategory,
    List<ImageModel>? image,
    RestaurantMenu? restaurantMenu,
  }) {
    return MealModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      restaurantMenuId: restaurantMenuId ?? this.restaurantMenuId,
      imageId: imageId ?? this.imageId,
      categoryId: categoryId ?? this.categoryId,
      subCategoryId: subCategoryId ?? this.subCategoryId,
      category: category ?? this.category,
      subcategory: subcategory ?? this.subcategory,
      image: image ?? this.image,
      restaurantMenu: restaurantMenu ?? this.restaurantMenu,
    );
  }
}

final _response = {
  "id": 3,
  "name": "meal name",
  "description": "meal description",
  "price": "1234.00",
  "restaurant_menu_id": 28,
  "image_id": 3,
  "category_id": 1,
  "sub_category_id": 1,
  "category": {"id": 1, "name": "Meat", "description": "Meat"},
  "subcategory": {
    "id": 1,
    "category_id": 1,
    "name": "Sheep Meat",
    "description": "Sheep Meat",
  },
  "image": [
    {
      "id": 3,
      "path": "storage/images/user/0fbadd14-bb68-40d6-98ce-345628332820.jpg",
      "imageable_type": "App\\Models\\Meal",
      "imageable_id": 3,
    },
  ],
  "restaurant_menu": {
    "id": 28,
    "restaurant_id": 6,
    "name": "menu name",
    "description": "menu description",
    "image_id": 1,
    "restaurant": {
      "id": 6,
      "user_id": 26,
      "vendor_id": 7,
      "website": null,
      "verified": 0,
    },
  },
};
