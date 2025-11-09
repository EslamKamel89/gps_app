class Location {
  int? latitude;
  int? longitude;

  Location({this.latitude, this.longitude});

  @override
  String toString() {
    return 'Location(latitude: $latitude, longitude: $longitude)';
  }

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    latitude: json['latitude'] as int?,
    longitude: json['longitude'] as int?,
  );

  Map<String, dynamic> toJson() => {
    'latitude': latitude,
    'longitude': longitude,
  };

  Location copyWith({int? latitude, int? longitude}) {
    return Location(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}
