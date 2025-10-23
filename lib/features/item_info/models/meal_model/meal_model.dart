import 'category.dart';
import 'image.dart';
import 'restaurant_menu.dart';
import 'subcategory.dart';

class MealModel {
  int? id;
  String? name;
  String? description;
  String? price;
  int? restaurantMenuId;
  int? imageId;
  int? categoryId;
  int? subCategoryId;
  Category? category;
  Subcategory? subcategory;
  List<Image>? image;
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
            : Category.fromJson(json['category'] as Map<String, dynamic>),
    subcategory:
        json['subcategory'] == null
            ? null
            : Subcategory.fromJson(json['subcategory'] as Map<String, dynamic>),
    image:
        (json['image'] as List<dynamic>?)
            ?.map((e) => Image.fromJson(e as Map<String, dynamic>))
            .toList(),
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
    Category? category,
    Subcategory? subcategory,
    List<Image>? image,
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
