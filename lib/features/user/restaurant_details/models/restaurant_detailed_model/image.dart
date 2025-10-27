class RestaurantImage {
  int? id;
  String? path;

  RestaurantImage({this.id, this.path});

  @override
  String toString() => 'Image(id: $id, path: $path)';

  factory RestaurantImage.fromJson(Map<String, dynamic> json) =>
      RestaurantImage(id: json['id'] as int?, path: json['path'] as String?);

  Map<String, dynamic> toJson() => {'id': id, 'path': path};

  RestaurantImage copyWith({int? id, String? path}) {
    return RestaurantImage(id: id ?? this.id, path: path ?? this.path);
  }
}
