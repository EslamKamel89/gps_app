class RestaurantMainData {
  int? id;
  int? verified;
  String? vendorName;
  String? path;

  RestaurantMainData({this.id, this.verified, this.vendorName, this.path});

  @override
  String toString() {
    return 'RestaurantMainData(id: $id, verified: $verified, vendorName: $vendorName, path: $path)';
  }

  factory RestaurantMainData.fromJson(Map<String, dynamic> json) {
    return RestaurantMainData(
      id: json['id'] as int?,
      verified: json['verified'] as int?,
      vendorName:
          json['vendor'] != null
              ? json['vendor']['vendor_name'] as String?
              : null,
      path:
          (json['user'] != null &&
                  json['user']['images'] != null &&
                  (json['user']['images'] as List).isNotEmpty)
              ? json['user']['images'][0]['path'] as String?
              : null,
    );
  }

  RestaurantMainData copyWith({
    int? id,
    int? verified,
    String? vendorName,
    String? path,
  }) {
    return RestaurantMainData(
      id: id ?? this.id,
      verified: verified ?? this.verified,
      vendorName: vendorName ?? this.vendorName,
      path: path ?? this.path,
    );
  }
}
