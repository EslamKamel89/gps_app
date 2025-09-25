class FarmModel {
  int? id;
  int? userId;
  int? vendorId;
  dynamic longitude;
  dynamic latitude;
  dynamic website;
  DateTime? createdAt;
  DateTime? updatedAt;

  FarmModel({
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
    return 'FarmModel(id: $id, userId: $userId, vendorId: $vendorId, longitude: $longitude, latitude: $latitude, website: $website, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  factory FarmModel.fromJson(Map<String, dynamic> json) => FarmModel(
    id: json['id'] as int?,
    userId: json['user_id'] as int?,
    vendorId: json['vendor_id'] as int?,
    longitude: json['longitude'] as dynamic,
    latitude: json['latitude'] as dynamic,
    website: json['website'] as dynamic,
    createdAt:
        json['created_at'] == null
            ? null
            : DateTime.parse(json['created_at'] as String),
    updatedAt:
        json['updated_at'] == null
            ? null
            : DateTime.parse(json['updated_at'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'vendor_id': vendorId,
    'longitude': longitude,
    'latitude': latitude,
    'website': website,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };

  FarmModel copyWith({
    int? id,
    int? userId,
    int? vendorId,
    dynamic longitude,
    dynamic latitude,
    dynamic website,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FarmModel(
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
