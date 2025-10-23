class StoreOrFarmModel {
  int? id;
  int? userId;
  int? vendorId;
  String? longitude;
  String? latitude;
  String? website;

  StoreOrFarmModel({
    this.id,
    this.userId,
    this.vendorId,
    this.longitude,
    this.latitude,
    this.website,
  });

  @override
  String toString() {
    return 'Store(id: $id, userId: $userId, vendorId: $vendorId, longitude: $longitude, latitude: $latitude, website: $website)';
  }

  factory StoreOrFarmModel.fromJson(Map<String, dynamic> json) => StoreOrFarmModel(
    id: json['id'] as int?,
    userId: json['user_id'] as int?,
    vendorId: json['vendor_id'] as int?,
    longitude: json['longitude'] as String?,
    latitude: json['latitude'] as String?,
    website: json['website'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'vendor_id': vendorId,
    'longitude': longitude,
    'latitude': latitude,
    'website': website,
  };

  StoreOrFarmModel copyWith({
    int? id,
    int? userId,
    int? vendorId,
    String? longitude,
    String? latitude,
    String? website,
  }) {
    return StoreOrFarmModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      vendorId: vendorId ?? this.vendorId,
      longitude: longitude ?? this.longitude,
      latitude: latitude ?? this.latitude,
      website: website ?? this.website,
    );
  }
}
