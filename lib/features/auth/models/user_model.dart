// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:gps_app/features/auth/models/farm_model.dart';
import 'package:gps_app/features/auth/models/image_model.dart';
import 'package:gps_app/features/auth/models/store_model.dart';
import 'package:gps_app/features/auth/models/vendor_model/vendor_model.dart';

import 'user_type_model.dart';

class UserModel {
  final int? id;
  final String? fullName;
  final String? userName;
  final String? email;
  final String? emailVerifiedAt;
  final String? mobile;
  final String? createdAt;
  final String? updatedAt;
  final int? userTypeId;
  final int? districtId;
  final int? stateId;
  final String? token;
  final UserTypeModel? userType;
  final VendorModel? vendor;
  final FarmModel? farm;
  final StoreModel? store;
  final ImageModel? image;

  const UserModel({
    this.id,
    this.fullName,
    this.userName,
    this.email,
    this.emailVerifiedAt,
    this.mobile,
    this.createdAt,
    this.updatedAt,
    this.userTypeId,
    this.districtId,
    this.stateId,
    this.token,
    this.userType,
    this.vendor,
    this.image,
    this.farm,
    this.store,
  });

  factory UserModel.fromJson(Map<String, dynamic> j) => UserModel(
    id: j['id'],
    fullName: j['full_name'],
    userName: j['user_name'],
    email: j['email'],
    emailVerifiedAt: j['email_verified_at'],
    mobile: j['mobile'],
    createdAt: j['created_at'],
    updatedAt: j['updated_at'],
    userTypeId: j['user_type_id'],
    districtId: j['district_id'],
    stateId: j['state_id'],
    token: j['token'],
    image: j['image'] == null ? null : ImageModel.fromJson(j['image']),
    userType: j['user_type'] == null ? null : UserTypeModel.fromJson(j['user_type']),
    vendor: j['vendor'] == null ? null : VendorModel.fromJson(j['vendor']),
    farm: j['farm'] == null ? null : FarmModel.fromJson(j['farm']),
    store: j['store'] == null ? null : StoreModel.fromJson(j['store']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'full_name': fullName,
    'user_name': userName,
    'email': email,
    'email_verified_at': emailVerifiedAt,
    'mobile': mobile,
    'created_at': createdAt,
    'updated_at': updatedAt,
    'user_type_id': userTypeId,
    'district_id': districtId,
    'state_id': stateId,
    'token': token,
    'image': image?.toJson(),
    'user_type': userType?.toJson(),
    'vendor': vendor?.toJson(),
    'farm': farm?.toJson(),
    'store': store?.toJson(),
  };

  @override
  String toString() {
    return 'UserModel(id: $id, fullName: $fullName, userName: $userName, email: $email, emailVerifiedAt: $emailVerifiedAt, mobile: $mobile, createdAt: $createdAt, updatedAt: $updatedAt, userTypeId: $userTypeId, districtId: $districtId, stateId: $stateId, token: $token, userType: $userType, vendor: $vendor , image: $image , farm: $farm , store: $store)';
  }
}

final _userExample = {
  "full_name": "Eslam Kamel",
  "user_name": "eslamkamel89",
  "email": "eslam@example.com",
  "mobile": "+2010...",
  "user_type_id": 4,
  "state_id": 1,
  "district_id": 1,
  "updated_at": "2025-09-25T16:34:43.000000Z",
  "created_at": "2025-09-25T16:34:43.000000Z",
  "id": 36,
  "token": "26|nOB3oJbzbwPDgvKlntYHcuPvCdlmcSmzNXLnDXUu8b449a4b",
  "user_type": {
    "id": 4,
    "type": "farm",
    "created_at": "2025-09-17T16:34:31.000000Z",
    "updated_at": "2025-09-17T16:34:31.000000Z",
  },
  "vendor": {
    "id": 15,
    "user_id": 36,
    "vendor_name": "eslam restaurant",
    "price_range": null,
    "address": "some address",
    "seating_capacity": null,
    "operating_hours": {
      "fri": ["08:00", "21:00"],
      "mon": ["08:00", "20:00"],
      "sat": ["09:00", "21:00"],
      "sun": ["09:00", "19:00"],
      "thu": ["08:00", "21:00"],
      "tue": ["08:00", "20:00"],
      "wed": ["08:00", "20:00"],
    },
    "created_at": "2025-09-25T16:34:43.000000Z",
    "updated_at": "2025-09-25T16:34:43.000000Z",
  },
  "farm": {
    "id": 1,
    "user_id": 36,
    "vendor_id": 15,
    "longitude": null,
    "latitude": null,
    "website": null,
    "created_at": "2025-09-25T16:34:43.000000Z",
    "updated_at": "2025-09-25T16:34:43.000000Z",
  },
  "store": null,
  "restaurant": null,
  "image": {
    "id": 41,
    "path": "storage/images/branches/pure-pastures-4-front.jpg",
    "imageable_type": "App\\Models\\User",
    "imageable_id": 36,
    "created_at": "2025-09-17T16:34:47.000000Z",
    "updated_at": "2025-09-25T16:34:43.000000Z",
  },
};
