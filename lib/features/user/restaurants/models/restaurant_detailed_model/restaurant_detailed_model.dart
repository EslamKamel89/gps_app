import 'branch.dart';
import 'certification.dart';
import 'menu.dart';
import 'user.dart';
import 'vendor.dart';

class RestaurantDetailedModel {
  int? id;
  String? website;
  int? verified;
  Vendor? vendor;
  User? user;
  List<Branch>? branches;
  List<Menu>? menus;
  List<Certification>? certifications;

  RestaurantDetailedModel({
    this.id,
    this.website,
    this.verified,
    this.vendor,
    this.user,
    this.branches,
    this.menus,
    this.certifications,
  });

  @override
  String toString() {
    return 'RestaurantDetailedModel(id: $id, website: $website, verified: $verified, vendor: $vendor, user: $user, branches: $branches, menus: $menus, certifications: $certifications)';
  }

  factory RestaurantDetailedModel.fromJson(Map<String, dynamic> json) {
    return RestaurantDetailedModel(
      id: json['id'] as int?,
      website: json['website'] as String?,
      verified: json['verified'] as int?,
      vendor:
          json['vendor'] == null
              ? null
              : Vendor.fromJson(json['vendor'] as Map<String, dynamic>),
      user:
          json['user'] == null
              ? null
              : User.fromJson(json['user'] as Map<String, dynamic>),
      branches:
          (json['branches'] as List<dynamic>?)
              ?.map((e) => Branch.fromJson(e as Map<String, dynamic>))
              .toList(),
      menus:
          (json['menus'] as List<dynamic>?)
              ?.map((e) => Menu.fromJson(e as Map<String, dynamic>))
              .toList(),
      certifications:
          (json['certifications'] as List<dynamic>?)
              ?.map((e) => Certification.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'website': website,
    'verified': verified,
    'vendor': vendor?.toJson(),
    'user': user?.toJson(),
    'branches': branches?.map((e) => e.toJson()).toList(),
    'menus': menus?.map((e) => e.toJson()).toList(),
    'certifications': certifications?.map((e) => e.toJson()).toList(),
  };

  RestaurantDetailedModel copyWith({
    int? id,
    String? website,
    int? verified,
    Vendor? vendor,
    User? user,
    List<Branch>? branches,
    List<Menu>? menus,
    List<Certification>? certifications,
  }) {
    return RestaurantDetailedModel(
      id: id ?? this.id,
      website: website ?? this.website,
      verified: verified ?? this.verified,
      vendor: vendor ?? this.vendor,
      user: user ?? this.user,
      branches: branches ?? this.branches,
      menus: menus ?? this.menus,
      certifications: certifications ?? this.certifications,
    );
  }
}
