class Restaurant {
  int? id;
  int? userId;
  int? vendorId;
  dynamic website;
  int? verified;

  Restaurant({
    this.id,
    this.userId,
    this.vendorId,
    this.website,
    this.verified,
  });

  @override
  String toString() {
    return 'Restaurant(id: $id, userId: $userId, vendorId: $vendorId, website: $website, verified: $verified)';
  }

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
    id: json['id'] as int?,
    userId: json['user_id'] as int?,
    vendorId: json['vendor_id'] as int?,
    website: json['website'] as dynamic,
    verified: json['verified'] as int?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'vendor_id': vendorId,
    'website': website,
    'verified': verified,
  };

  Restaurant copyWith({
    int? id,
    int? userId,
    int? vendorId,
    dynamic website,
    int? verified,
  }) {
    return Restaurant(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      vendorId: vendorId ?? this.vendorId,
      website: website ?? this.website,
      verified: verified ?? this.verified,
    );
  }
}
