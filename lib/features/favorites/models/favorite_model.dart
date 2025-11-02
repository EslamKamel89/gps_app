import 'package:gps_app/features/auth/models/user_model.dart';

class FavoriteModel {
  int? id;
  String? favoriteType;
  int? favoriteId;
  UserModel? user;

  FavoriteModel({this.id, this.favoriteType, this.favoriteId, this.user});

  @override
  String toString() {
    return 'FavoriteModel(id: $id, favoriteType: $favoriteType, favoriteId: $favoriteId)';
  }

  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteModel(
      id: json['id'] as int?,
      favoriteType: json['favourite_type'] as String?,
      favoriteId: json['favourite_id'] as int?,
      user: json['details'] == null ? null : UserModel.fromJson(json['details']),
    );
  }
}
