import 'package:gps_app/features/auth/models/district_model.dart';
import 'package:gps_app/features/auth/models/state_model.dart';

import 'image.dart';

class Branch {
  int? id;
  String? branchName;
  String? phoneNumber;
  String? website;
  String? longitude;
  String? latitude;
  int? stateId;
  int? districtId;
  StateModel? state;
  DistrictModel? district;
  List<RestaurantImage>? images;

  Branch({
    this.id,
    this.branchName,
    this.phoneNumber,
    this.website,
    this.longitude,
    this.latitude,
    this.images,
    this.state,
    this.district,
    this.stateId,
    this.districtId,
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
    stateId: json['state_id'] as int?,
    districtId: json['district_id'] as int?,
    state:
        json['state'] == null ? null : StateModel.fromJson(json['state'] as Map<String, dynamic>),
    district:
        json['district'] == null
            ? null
            : DistrictModel.fromJson(json['district'] as Map<String, dynamic>),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'branch_name': branchName,
    'phone_number': phoneNumber,
    'website': website,
    'longitude': longitude,
    'latitude': latitude,
    'state_id': stateId,
    'district_id': districtId,
    'state': state?.toJson(),
    'district': district?.toJson(),
    'images': images?.map((e) => e.toJson()).toList(),
  };
  Map<String, dynamic> toRequestBody() => {
    'branch_name': branchName,
    'phone_number': phoneNumber,
    'website': website,
    'longitude': longitude,
    'latitude': latitude,
    'state_id': stateId,
    'district_id': districtId,
    'image_id': images?.isNotEmpty == true ? images![0].id : null,
  };
}
