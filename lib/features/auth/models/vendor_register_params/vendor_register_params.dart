import 'package:gps_app/features/auth/models/operating_time_model.dart';

import 'price_range.dart';

class VendorRegisterParams {
  String? fullName;
  String? userName;
  String? email;
  String? mobile;
  String? password;
  int? stateId;
  int? districtId;
  int? imageId;
  String? vendorName;
  PriceRange? priceRange;
  String? address;
  int? seatingCapacity;
  String? userType;
  OperatingTimeModel? operatingHours;
  List<int>? holidayIds;
  double? longitude;
  double? latitude;

  VendorRegisterParams({
    this.fullName,
    this.userName,
    this.email,
    this.mobile,
    this.password,
    this.stateId,
    this.districtId,
    this.imageId,
    this.vendorName,
    this.priceRange,
    this.address,
    this.seatingCapacity,
    this.userType,
    this.operatingHours,
    this.holidayIds,
    this.longitude,
    this.latitude,
  });

  @override
  String toString() {
    return 'VendorRegisterParams(fullName: $fullName, userName: $userName, email: $email, mobile: $mobile, password: $password, stateId: $stateId, districtId: $districtId, imageId: $imageId, vendorName: $vendorName, priceRange: $priceRange, address: $address, seatingCapacity: $seatingCapacity, userType: $userType, operatingHours: $operatingHours , holidayIds: $holidayIds , latitude: $latitude , longitude: $longitude)';
  }

  factory VendorRegisterParams.fromJson(Map<String, dynamic> json) {
    return VendorRegisterParams(
      fullName: json['full_name'] as String?,
      userName: json['user_name'] as String?,
      email: json['email'] as String?,
      mobile: json['mobile'] as String?,
      password: json['password'] as String?,
      stateId: json['state_id'] as int?,
      districtId: json['district_id'] as int?,
      imageId: json['image_id'] as int?,
      vendorName: json['vendor_name'] as String?,
      priceRange:
          json['price_range'] == null
              ? null
              : PriceRange.fromJson(
                json['price_range'] as Map<String, dynamic>,
              ),
      address: json['address'] as String?,
      seatingCapacity: json['seating_capacity'] as int?,
      userType: json['user_type'] as String?,
      operatingHours:
          json['operating_hours'] == null
              ? null
              : OperatingTimeModel.fromJson(
                json['operating_hours'] as Map<String, dynamic>,
              ),
      latitude: json['latitude'] as double?,
      longitude: json['longitude'] as double?,
    );
  }

  Map<String, dynamic> toJson() => {
    'full_name': fullName,
    'user_name': userName,
    'email': email,
    'mobile': mobile,
    'password': password,
    'state_id': stateId,
    'district_id': districtId,
    'image_id': imageId,
    'vendor_name': vendorName,
    'price_range': priceRange?.toJson(),
    'address': address,
    'seating_capacity': seatingCapacity,
    'user_type': userType,
    'operating_hours': operatingHours?.toJson(),
    'holiday_ids': holidayIds,
    'latitude': latitude,
    'longitude': longitude,
  };

  VendorRegisterParams copyWith({
    String? fullName,
    String? userName,
    String? email,
    String? mobile,
    String? password,
    int? stateId,
    int? districtId,
    int? imageId,
    String? vendorName,
    PriceRange? priceRange,
    String? address,
    int? seatingCapacity,
    String? userType,
    OperatingTimeModel? operatingHours,
    List<int>? holidayIds,
    double? latitude,
    double? longitude,
  }) {
    return VendorRegisterParams(
      fullName: fullName ?? this.fullName,
      userName: userName ?? this.userName,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      password: password ?? this.password,
      stateId: stateId ?? this.stateId,
      districtId: districtId ?? this.districtId,
      imageId: imageId ?? this.imageId,
      vendorName: vendorName ?? this.vendorName,
      priceRange: priceRange ?? this.priceRange,
      address: address ?? this.address,
      seatingCapacity: seatingCapacity ?? this.seatingCapacity,
      userType: userType ?? this.userType,
      operatingHours: operatingHours ?? this.operatingHours,
      holidayIds: holidayIds ?? this.holidayIds,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}
