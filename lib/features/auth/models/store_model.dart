class StoreModel {
  int? id;
  int? userId;
  int? vendorId;
  double? longitude;
  double? latitude;
  String? website;
  String? createdAt;
  String? updatedAt;

  StoreModel({
    this.id,
    this.userId,
    this.vendorId,
    this.longitude,
    this.latitude,
    this.website,
    this.createdAt,
    this.updatedAt,
  });

  @override
  String toString() {
    return 'StoreModel(id: $id, userId: $userId, vendorId: $vendorId, longitude: $longitude, latitude: $latitude, website: $website, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  factory StoreModel.fromJson(Map<String, dynamic> json) => StoreModel(
    id: json['id'] as int?,
    userId: json['user_id'] as int?,
    vendorId: json['vendor_id'] as int?,
    longitude: json['longitude'] as double?,
    latitude: json['latitude'] as double?,
    website: json['website'] as String?,
    createdAt: json['created_at'] as String?,
    updatedAt: json['updated_at'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'vendor_id': vendorId,
    'longitude': longitude,
    'latitude': latitude,
    'website': website,
    'created_at': createdAt,
    'updated_at': updatedAt,
  };

  StoreModel copyWith({
    int? id,
    int? userId,
    int? vendorId,
    double? longitude,
    double? latitude,
    String? website,
    String? createdAt,
    String? updatedAt,
  }) {
    return StoreModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      vendorId: vendorId ?? this.vendorId,
      longitude: longitude ?? this.longitude,
      latitude: latitude ?? this.latitude,
      website: website ?? this.website,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
