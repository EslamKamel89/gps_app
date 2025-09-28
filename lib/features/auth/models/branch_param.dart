class BranchParam {
  String? branchName;
  String? phoneNumber;
  String? website;
  double? longitude;
  double? latitude;
  bool? status;
  int? districtId;
  int? stateId;
  int? imageId;

  BranchParam({
    this.branchName,
    this.phoneNumber,
    this.website,
    this.longitude,
    this.latitude,
    this.status,
    this.districtId,
    this.stateId,
    this.imageId,
  });

  @override
  String toString() {
    return 'BranchParam(branchName: $branchName, phoneNumber: $phoneNumber, website: $website, longitude: $longitude, latitude: $latitude, status: $status, districtId: $districtId, stateId: $stateId, imageId: $imageId)';
  }

  factory BranchParam.fromJson(Map<String, dynamic> json) => BranchParam(
    branchName: json['branch_name'] as String?,
    phoneNumber: json['phone_number'] as String?,
    website: json['website'] as String?,
    longitude: (json['longitude'] as num?)?.toDouble(),
    latitude: (json['latitude'] as num?)?.toDouble(),
    status: json['status'] as bool?,
    districtId: json['district_id'] as int?,
    stateId: json['state_id'] as int?,
    imageId: json['image_id'] as int?,
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
    'image_id': imageId,
  };

  BranchParam copyWith({
    String? branchName,
    String? phoneNumber,
    String? website,
    double? longitude,
    double? latitude,
    bool? status,
    int? districtId,
    int? stateId,
    int? imageId,
  }) {
    return BranchParam(
      branchName: branchName ?? this.branchName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      website: website ?? this.website,
      longitude: longitude ?? this.longitude,
      latitude: latitude ?? this.latitude,
      status: status ?? this.status,
      districtId: districtId ?? this.districtId,
      stateId: stateId ?? this.stateId,
      imageId: imageId ?? this.imageId,
    );
  }
}
