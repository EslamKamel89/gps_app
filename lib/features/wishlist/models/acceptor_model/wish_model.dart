import 'package:gps_app/features/auth/models/user_model.dart';
import 'package:gps_app/features/user/categories/models/category_model/category_model.dart';
import 'package:gps_app/features/user/categories/models/category_model/sub_category_model.dart';
import 'package:gps_app/features/wishlist/models/acceptor_model/acceptor_model.dart';

class WishModel {
  final int? id;
  final String? description;
  final int? status;
  final int? acceptorsCount;
  final UserModel? user;
  final CategoryModel? category;
  final SubCategoryModel? subcategory;
  final List<AcceptorModel>? acceptors;

  WishModel({
    this.id,
    this.description,
    this.acceptorsCount,
    this.status,
    this.acceptors,
    this.category,
    this.subcategory,
    this.user,
  });

  bool get hasMatches => acceptors?.isNotEmpty == true;
  factory WishModel.fromJson(Map<String, dynamic> json) => WishModel(
    id: json['id'] as int?,
    description: json['description'] as String?,
    status: json['status'] as int?,
    acceptorsCount: json['acceptors_count'] as int?,
    user:
        json['user'] == null
            ? null
            : UserModel.fromJson(json['user'] as Map<String, dynamic>),
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
    acceptors:
        (json['acceptors'] as List<dynamic>?)
            ?.map((e) => AcceptorModel.fromJson(e as Map<String, dynamic>))
            .toList(),
  );
}
