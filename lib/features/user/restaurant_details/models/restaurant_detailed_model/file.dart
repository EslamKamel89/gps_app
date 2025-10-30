class RestaurantFile {
  String? path;
  int? id;
  RestaurantFile({this.path, this.id});

  @override
  String toString() => 'File(path: $path , id: $id)';

  factory RestaurantFile.fromJson(Map<String, dynamic> json) =>
      RestaurantFile(id: json['id'] as int?, path: json['path'] as String?);

  Map<String, dynamic> toJson() => {'path': path, 'id': id};

  RestaurantFile copyWith({String? path, int? id}) {
    return RestaurantFile(id: id ?? this.id, path: path ?? this.path);
  }
}
