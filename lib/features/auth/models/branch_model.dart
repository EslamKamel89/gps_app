class BranchModel {
  String? branchName;
  String? phoneNumber;
  String? website;
  double? longitude;
  double? latitude;
  bool? status;
  int? districtId;
  int? stateId;
  int? userId;
  int? vendorId;
  int? restaurantId;
  DateTime? updatedAt;
  DateTime? createdAt;
  int? id;
  dynamic image;

  BranchModel({
    this.branchName,
    this.phoneNumber,
    this.website,
    this.longitude,
    this.latitude,
    this.status,
    this.districtId,
    this.stateId,
    this.userId,
    this.vendorId,
    this.restaurantId,
    this.updatedAt,
    this.createdAt,
    this.id,
    this.image,
  });

  @override
  String toString() {
    return 'BranchModel(branchName: $branchName, phoneNumber: $phoneNumber, website: $website, longitude: $longitude, latitude: $latitude, status: $status, districtId: $districtId, stateId: $stateId, userId: $userId, vendorId: $vendorId, restaurantId: $restaurantId, updatedAt: $updatedAt, createdAt: $createdAt, id: $id, image: $image)';
  }

  factory BranchModel.fromJson(Map<String, dynamic> json) => BranchModel(
    branchName: json['branch_name'] as String?,
    phoneNumber: json['phone_number'] as String?,
    website: json['website'] as String?,
    longitude: (json['longitude'] as num?)?.toDouble(),
    latitude: (json['latitude'] as num?)?.toDouble(),
    status: json['status'] as bool?,
    districtId: json['district_id'] as int?,
    stateId: json['state_id'] as int?,
    userId: json['user_id'] as int?,
    vendorId: json['vendor_id'] as int?,
    restaurantId: json['restaurant_id'] as int?,
    updatedAt:
        json['updated_at'] == null
            ? null
            : DateTime.parse(json['updated_at'] as String),
    createdAt:
        json['created_at'] == null
            ? null
            : DateTime.parse(json['created_at'] as String),
    id: json['id'] as int?,
    image: json['image'] as dynamic,
  );

  Map<String, dynamic> toJson() => {
    'branch_name': branchName,
    'phone_number': phoneNumber,
    'website': website,
    'longitude': longitude,
    'latitude': latitude,
    'status': status,
    'district_id': districtId,
    'state_id': stateId,
    'user_id': userId,
    'vendor_id': vendorId,
    'restaurant_id': restaurantId,
    'updated_at': updatedAt?.toIso8601String(),
    'created_at': createdAt?.toIso8601String(),
    'id': id,
    'image': image,
  };

  BranchModel copyWith({
    String? branchName,
    String? phoneNumber,
    String? website,
    double? longitude,
    double? latitude,
    bool? status,
    int? districtId,
    int? stateId,
    int? userId,
    int? vendorId,
    int? restaurantId,
    DateTime? updatedAt,
    DateTime? createdAt,
    int? id,
    dynamic image,
  }) {
    return BranchModel(
      branchName: branchName ?? this.branchName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      website: website ?? this.website,
      longitude: longitude ?? this.longitude,
      latitude: latitude ?? this.latitude,
      status: status ?? this.status,
      districtId: districtId ?? this.districtId,
      stateId: stateId ?? this.stateId,
      userId: userId ?? this.userId,
      vendorId: vendorId ?? this.vendorId,
      restaurantId: restaurantId ?? this.restaurantId,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
      id: id ?? this.id,
      image: image ?? this.image,
    );
  }
}
