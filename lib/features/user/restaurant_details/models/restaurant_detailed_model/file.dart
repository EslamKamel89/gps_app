class RestaurantFile {
  String? path;

  RestaurantFile({this.path});

  @override
  String toString() => 'File(path: $path)';

  factory RestaurantFile.fromJson(Map<String, dynamic> json) =>
      RestaurantFile(path: json['path'] as String?);

  Map<String, dynamic> toJson() => {'path': path};

  RestaurantFile copyWith({String? path}) {
    return RestaurantFile(path: path ?? this.path);
  }
}
