import 'package:gps_app/features/auth/models/branch_model.dart';

class RestaurantModel {
  int? id;
  int? userId;
  int? vendorId;
  dynamic website;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<BranchModel>? branches;
  bool? menus;
  bool? certificates;

  RestaurantModel({
    this.id,
    this.userId,
    this.vendorId,
    this.website,
    this.createdAt,
    this.updatedAt,
    this.branches,
    this.menus,
    this.certificates,
  });

  @override
  String toString() {
    return 'RestaurantModel(id: $id, userId: $userId, vendorId: $vendorId, website: $website, branches length: ${branches?.length} , menus: $menus , certifications: $certificates)';
  }

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
      id: json['id'] as int?,
      userId: json['user_id'] as int?,
      vendorId: json['vendor_id'] as int?,
      website: json['website'] as dynamic,
      createdAt: json['created_at'] == null ? null : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null ? null : DateTime.parse(json['updated_at'] as String),
      branches:
          (json['branches'] as List<dynamic>?)
              ?.map((e) => BranchModel.fromJson(e as Map<String, dynamic>))
              .toList(),
      menus:
          json['branches'] is bool
              ? json['branches']
              : (json['branches'] as List<dynamic>?)?.isNotEmpty == true,
      certificates:
          json['certificates'] is bool
              ? json['certificates']
              : (json['certificates'] as List<dynamic>?)?.isNotEmpty == true,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'vendor_id': vendorId,
    'website': website,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
    'branches': branches?.map((e) => e.toJson()).toList(),
    'menus': menus,
    'certificates': certificates,
  };

  RestaurantModel copyWith({
    int? id,
    int? userId,
    int? vendorId,
    dynamic website,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<BranchModel>? branches,
    bool? menus,
    bool? certificates,
  }) {
    return RestaurantModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      vendorId: vendorId ?? this.vendorId,
      website: website ?? this.website,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      branches: branches ?? this.branches,
      menus: menus ?? this.menus,
      certificates: certificates ?? this.certificates,
    );
  }
}
