import 'image.dart';

class Branch {
  int? id;
  String? branchName;
  String? phoneNumber;
  String? website;
  String? longitude;
  String? latitude;
  List<RestaurantImage>? images;

  Branch({
    this.id,
    this.branchName,
    this.phoneNumber,
    this.website,
    this.longitude,
    this.latitude,
    this.images,
  });

  @override
  String toString() {
    return 'Branch(id: $id, branchName: $branchName, phoneNumber: $phoneNumber, website: $website, longitude: $longitude, latitude: $latitude, images: $images)';
  }

  factory Branch.fromJson(Map<String, dynamic> json) => Branch(
    id: json['id'] as int?,
    branchName: json['branch_name'] as String?,
    phoneNumber: json['phone_number'] as String?,
    website: json['website'] as String?,
    longitude: json['longitude'] as String?,
    latitude: json['latitude'] as String?,
    images:
        (json['images'] as List<dynamic>?)
            ?.map((e) => RestaurantImage.fromJson(e as Map<String, dynamic>))
            .toList(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'branch_name': branchName,
    'phone_number': phoneNumber,
    'website': website,
    'longitude': longitude,
    'latitude': latitude,
    'images': images?.map((e) => e.toJson()).toList(),
  };

  Branch copyWith({
    int? id,
    String? branchName,
    String? phoneNumber,
    String? website,
    String? longitude,
    String? latitude,
    List<RestaurantImage>? images,
  }) {
    return Branch(
      id: id ?? this.id,
      branchName: branchName ?? this.branchName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      website: website ?? this.website,
      longitude: longitude ?? this.longitude,
      latitude: latitude ?? this.latitude,
      images: images ?? this.images,
    );
  }
}
