import 'package:gps_app/features/auth/models/operating_time_model.dart';
import 'package:gps_app/features/auth/models/vendor_register_params/price_range.dart';

class VendorModel {
  int? id;
  int? userId;
  String? vendorName;
  PriceRange? priceRange;
  String? address;
  int? seatingCapacity;
  int? isActive;
  OperatingTimeModel? operatingHours;
  DateTime? createdAt;
  DateTime? updatedAt;

  VendorModel({
    this.id,
    this.userId,
    this.vendorName,
    this.priceRange,
    this.address,
    this.isActive,
    this.seatingCapacity,
    this.operatingHours,
    this.createdAt,
    this.updatedAt,
  });

  @override
  String toString() {
    return 'VendorModel(id: $id, userId: $userId, isActive: $isActive vendorName: $vendorName, priceRange: $priceRange, address: $address, seatingCapacity: $seatingCapacity, operatingHours: $operatingHours, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  factory VendorModel.fromJson(Map<String, dynamic> json) => VendorModel(
    id: json['id'] as int?,
    isActive: json['is_active'] as int?,
    // isActive: 1,
    userId: json['user_id'] as int?,
    vendorName: json['vendor_name'] as String?,
    // priceRange:
    //     json['price_range'] == null
    //         ? null
    //         : PriceRange.fromJson(json['price_range'] as Map<String, dynamic>),
    address: json['address'] as String?,
    seatingCapacity: json['seating_capacity'] as int?,
    operatingHours:
        json['operating_hours'] == null
            ? null
            : OperatingTimeModel.fromJson(json['operating_hours'] as Map<String, dynamic>),
    createdAt: json['created_at'] == null ? null : DateTime.parse(json['created_at'] as String),
    updatedAt: json['updated_at'] == null ? null : DateTime.parse(json['updated_at'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'is_active': isActive,
    'vendor_name': vendorName,
    'price_range': priceRange?.toJson(),
    'address': address,
    'seating_capacity': seatingCapacity,
    'operating_hours': operatingHours?.toJson(),
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };

  VendorModel copyWith({
    int? id,
    int? userId,
    int? isActive,
    String? vendorName,
    PriceRange? priceRange,
    String? address,
    int? seatingCapacity,
    OperatingTimeModel? operatingHours,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return VendorModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      isActive: isActive ?? this.isActive,
      vendorName: vendorName ?? this.vendorName,
      priceRange: priceRange ?? this.priceRange,
      address: address ?? this.address,
      seatingCapacity: seatingCapacity ?? this.seatingCapacity,
      operatingHours: operatingHours ?? this.operatingHours,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
