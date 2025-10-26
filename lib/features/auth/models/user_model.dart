// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:gps_app/features/auth/models/catalog_section_model.dart';
import 'package:gps_app/features/auth/models/district_model.dart';
import 'package:gps_app/features/auth/models/farm_model.dart';
import 'package:gps_app/features/auth/models/image_model.dart';
import 'package:gps_app/features/auth/models/restaurant_model.dart';
import 'package:gps_app/features/auth/models/state_model.dart';
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
  final RestaurantModel? restaurant;
  final ImageModel? image;
  final StateModel? state;
  final DistrictModel? district;

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
    this.restaurant,
    this.state,
    this.district,
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
    restaurant: j['restaurant'] == null ? null : RestaurantModel.fromJson(j['restaurant']),
    state: j['state'] == null ? null : StateModel.fromJson(j['state']),
    district: j['district'] == null ? null : DistrictModel.fromJson(j['district']),
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
    'restaurant': restaurant?.toJson(),
    'state': state?.toJson(),
    'district': district?.toJson(),
  };

  @override
  String toString() {
    // return 'UserModel(restaurant: $restaurant)';
    return 'UserModel(id: $id, fullName: $fullName, userName: $userName, email: $email, emailVerifiedAt: $emailVerifiedAt, mobile: $mobile, createdAt: $createdAt, updatedAt: $updatedAt, userTypeId: $userTypeId, districtId: $districtId, stateId: $stateId, token: $token, userType: $userType, vendor: $vendor , image: $image , farm: $farm , store: $store , restaurant: $restaurant)';
  }

  List<CatalogSectionModel> sections() {
    return [...(farm?.sections ?? []), ...(store?.sections ?? [])];
  }
}

final _restaurant = {
  "id": 17,
  "full_name": "Eslam Kamel",
  "user_name": "eslamkamel89",
  "email": "eslam@example.com",
  "email_verified_at": "2025-09-29T00:49:43.000000Z",
  "mobile": "+2010...",
  "created_at": "2025-09-28T21:46:56.000000Z",
  "updated_at": "2025-09-28T21:46:56.000000Z",
  "user_type_id": 3,
  "district_id": 1,
  "state_id": 1,
  "token": "5|tlKx4GzpKGqxFb9pvhsWs7VGPltYlSvNsKYvPkmea4b86563",
  "user_type": {
    "id": 3,
    "type": "restaurant",
    "created_at": "2025-09-28T20:10:14.000000Z",
    "updated_at": "2025-09-28T20:10:14.000000Z",
  },
  "image": null,
  "vendor": {
    "id": 4,
    "user_id": 17,
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
    "created_at": "2025-09-28T21:46:56.000000Z",
    "updated_at": "2025-09-28T21:46:56.000000Z",
  },
  "restaurant": {
    "id": 3,
    "user_id": 17,
    "vendor_id": 4,
    "website": null,
    "created_at": "2025-09-28T21:46:56.000000Z",
    "updated_at": "2025-09-28T21:46:56.000000Z",
    "branches": [
      {
        "id": 9,
        "branch_name": "Downtown Branch",
        "phone_number": "123456789",
        "website": "https://downtown.example.com",
        "longitude": "31.12345678",
        "latitude": "30.98765432",
        "status": 1,
        "district_id": 1,
        "state_id": 2,
        "restaurant_id": 3,
        "user_id": 17,
        "vendor_id": 4,
        "created_at": "2025-09-28T21:47:15.000000Z",
        "updated_at": "2025-09-28T21:47:15.000000Z",
      },
      {
        "id": 10,
        "branch_name": "Uptown Branch",
        "phone_number": null,
        "website": null,
        "longitude": "30.45678912",
        "latitude": "29.65432109",
        "status": 0,
        "district_id": 3,
        "state_id": 2,
        "restaurant_id": 3,
        "user_id": 17,
        "vendor_id": 4,
        "created_at": "2025-09-28T21:47:15.000000Z",
        "updated_at": "2025-09-28T21:47:15.000000Z",
      },
    ],
  },
};

final _store = {
  "id": 18,
  "full_name": "Eslam Kamel",
  "user_name": "eslamkamel89",
  "email": "eslam@example.com",
  "email_verified_at": null,
  "mobile": "+2010...",
  "created_at": "2025-09-28T21:58:31.000000Z",
  "updated_at": "2025-09-28T21:58:31.000000Z",
  "user_type_id": 5,
  "district_id": 1,
  "state_id": 1,
  "token": "7|ULig8GVFohFeg983fYg8pkGmBlyzYzE8bQgGw735ab869cad",
  "user_type": {
    "id": 5,
    "type": "store",
    "created_at": "2025-09-28T20:10:14.000000Z",
    "updated_at": "2025-09-28T20:10:14.000000Z",
  },
  "image": null,
  "vendor": {
    "id": 5,
    "user_id": 18,
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
    "created_at": "2025-09-28T21:58:31.000000Z",
    "updated_at": "2025-09-28T21:58:31.000000Z",
  },
  "store": {
    "id": 1,
    "user_id": 18,
    "vendor_id": 5,
    "longitude": null,
    "latitude": null,
    "website": null,
    "created_at": "2025-09-28T21:58:31.000000Z",
    "updated_at": "2025-09-28T21:58:31.000000Z",
    "sections": [
      {
        "id": 1,
        "user_id": 18,
        "vendor_id": 5,
        "farm_id": null,
        "store_id": 1,
        "name": "section a",
        "status": true,
        "position": 1,
        "created_at": "2025-09-28T21:59:08.000000Z",
        "updated_at": "2025-09-28T21:59:08.000000Z",
        "items": [
          {
            "id": 1,
            "user_id": 18,
            "vendor_id": 5,
            "farm_id": null,
            "store_id": 1,
            "catalog_section_id": 1,
            "name": "item a-1",
            "price": "2000.00",
            "description": "item a-1 description",
            "status": true,
            "position": 1,
            "created_at": "2025-09-28T21:59:08.000000Z",
            "updated_at": "2025-09-28T21:59:08.000000Z",
          },
        ],
      },
    ],
  },
};

final _farm = {
  "id": 19,
  "full_name": "Eslam Kamel",
  "user_name": "eslamkamel89",
  "email": "eslam@example.com",
  "email_verified_at": null,
  "mobile": "+2010...",
  "created_at": "2025-09-28T22:00:41.000000Z",
  "updated_at": "2025-09-28T22:00:41.000000Z",
  "user_type_id": 4,
  "district_id": 1,
  "state_id": 1,
  "token": "9|oGApdIMv2SGFMB44V3PvhE4dqq5ZDdbwJdqluz9aea070678",
  "user_type": {
    "id": 4,
    "type": "farm",
    "created_at": "2025-09-28T20:10:14.000000Z",
    "updated_at": "2025-09-28T20:10:14.000000Z",
  },
  "image": null,
  "vendor": {
    "id": 6,
    "user_id": 19,
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
    "created_at": "2025-09-28T22:00:41.000000Z",
    "updated_at": "2025-09-28T22:00:41.000000Z",
  },
  "farm": {
    "id": 1,
    "user_id": 19,
    "vendor_id": 6,
    "longitude": null,
    "latitude": null,
    "website": null,
    "created_at": "2025-09-28T22:00:41.000000Z",
    "updated_at": "2025-09-28T22:00:41.000000Z",
    "sections": [
      {
        "id": 2,
        "user_id": 19,
        "vendor_id": 6,
        "farm_id": 1,
        "store_id": null,
        "name": "section a",
        "status": true,
        "position": 1,
        "created_at": "2025-09-28T22:01:09.000000Z",
        "updated_at": "2025-09-28T22:01:09.000000Z",
        "items": [
          {
            "id": 2,
            "user_id": 19,
            "vendor_id": 6,
            "farm_id": 1,
            "store_id": null,
            "catalog_section_id": 2,
            "name": "item a-1",
            "price": "2000.00",
            "description": "item a-1 description",
            "status": true,
            "position": 1,
            "created_at": "2025-09-28T22:01:09.000000Z",
            "updated_at": "2025-09-28T22:01:09.000000Z",
          },
        ],
      },
    ],
  },
};
