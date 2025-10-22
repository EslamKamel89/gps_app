import 'package:gps_app/features/auth/models/user_model.dart';
import 'package:gps_app/features/wishlist/entities/item_model.dart';

class AcceptorModel {
  final int? id;
  final int? wishlistId;
  final double? rating;
  final double? distanceKm;
  final String? itemType;
  final UserModel? user;
  final ItemModel? item;

  AcceptorModel({
    this.id,
    this.wishlistId,
    this.rating,
    this.distanceKm,
    this.item,
    this.user,
    this.itemType,
  });
  factory AcceptorModel.fromJson(Map<String, dynamic> json) => AcceptorModel(
    id: json['id'] as int?,
    wishlistId: json['wishlist_id'] as int?,
    itemType: json['item_type'] as String?,
    item: json['item'] == null ? null : ItemModel.fromJson(json['item'] as Map<String, dynamic>),
    user: json['user'] == null ? null : UserModel.fromJson(json['user'] as Map<String, dynamic>),
  );
}
