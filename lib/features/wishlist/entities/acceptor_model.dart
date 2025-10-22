import 'package:gps_app/features/wishlist/entities/item_model.dart';

class AcceptorModel {
  final String id;
  final String restaurantName;
  final double rating;
  final double distanceKm;
  final ItemModel item;
  final String? itemType;

  AcceptorModel({
    required this.id,
    required this.restaurantName,
    required this.rating,
    required this.distanceKm,
    required this.item,
    this.itemType,
  });
}
