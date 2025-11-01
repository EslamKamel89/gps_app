// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:gps_app/features/auth/models/user_model.dart';
import 'package:gps_app/features/wishlist/models/acceptor_model/item_model.dart';

class AcceptorModel {
  final int? id;
  final int? wishlistId;
  final int? userId;
  final double? rating;
  final double? distanceKm;
  final String? itemType;
  final UserModel? user;
  final ItemModel? item;

  AcceptorModel({
    this.id,
    this.wishlistId,
    this.userId,
    this.rating,
    this.distanceKm,
    this.item,
    this.user,
    this.itemType,
  });
  factory AcceptorModel.fromJson(Map<String, dynamic> json) => AcceptorModel(
    id: json['id'] as int?,
    userId: json['user_id'] as int?,
    wishlistId: json['wishlist_id'] as int?,
    itemType: json['item_type'] as String?,
    item:
        json['item'] == null
            ? null
            : ItemModel.fromJson(json['item'] as Map<String, dynamic>),
    user:
        json['user'] == null
            ? null
            : UserModel.fromJson(json['user'] as Map<String, dynamic>),
  );

  @override
  String toString() {
    return 'AcceptorModel(id: $id, userId: $userId , wishlistId: $wishlistId, rating: $rating, distanceKm: $distanceKm, itemType: $itemType, user: $user, item: $item)';
  }
}
