import 'location.dart';

class SuggestionModel {
  String? type;
  int? userId;
  int? vendorId;
  int? restaurantId;
  String? name;
  String? image;
  double? distance;
  String? address;
  Location? location;

  SuggestionModel({
    this.type,
    this.userId,
    this.vendorId,
    this.restaurantId,
    this.name,
    this.image,
    this.distance,
    this.address,
    this.location,
  });

  @override
  String toString() {
    return 'SuggestionModel(type: $type, userId: $userId, vendorId: $vendorId, restaurantId: $restaurantId, name: $name, image: $image, distance: $distance, address: $address, location: $location)';
  }

  factory SuggestionModel.fromJson(Map<String, dynamic> json) {
    return SuggestionModel(
      type: json['type'] as String?,
      userId: json['user_id'] as int?,
      vendorId: json['vendor_id'] as int?,
      restaurantId: json['restaurant_id'] as int?,
      name: json['name'] as String?,
      image: json['image'] as String?,
      distance: (json['distance'] as num?)?.toDouble(),
      address: json['address'] as String?,
      location:
          json['location'] == null
              ? null
              : Location.fromJson(json['location'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
    'type': type,
    'user_id': userId,
    'vendor_id': vendorId,
    'restaurant_id': restaurantId,
    'name': name,
    'image': image,
    'distance': distance,
    'address': address,
    'location': location?.toJson(),
  };

  SuggestionModel copyWith({
    String? type,
    int? userId,
    int? vendorId,
    int? restaurantId,
    String? name,
    String? image,
    double? distance,
    String? address,
    Location? location,
  }) {
    return SuggestionModel(
      type: type ?? this.type,
      userId: userId ?? this.userId,
      vendorId: vendorId ?? this.vendorId,
      restaurantId: restaurantId ?? this.restaurantId,
      name: name ?? this.name,
      image: image ?? this.image,
      distance: distance ?? this.distance,
      address: address ?? this.address,
      location: location ?? this.location,
    );
  }
}
