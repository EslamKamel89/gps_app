import 'package:gps_app/features/user/categories/models/category_model/category_model.dart';
import 'package:gps_app/features/user/categories/models/category_model/sub_category_model.dart';
import 'package:gps_app/features/wishlist/entities/acceptor_model.dart';

class WishModel {
  final String id;
  final String description;
  final int status;
  final CategoryModel? category;
  final SubCategoryModel? subCategoryModel;
  final List<AcceptorModel> acceptors;

  WishModel({
    required this.id,
    required this.description,
    required this.status,
    required this.acceptors,
    this.category,
    this.subCategoryModel,
  });

  bool get hasMatches => acceptors.isNotEmpty;
}
