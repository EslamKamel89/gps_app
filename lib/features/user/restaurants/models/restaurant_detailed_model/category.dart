class Category {
  int? id;
  String? path;

  Category({this.id, this.path});

  @override
  String toString() => 'Category(id: $id, path: $path)';

  factory Category.fromJson(Map<String, dynamic> json) =>
      Category(id: json['id'] as int?, path: json['path'] as String?);

  Map<String, dynamic> toJson() => {'id': id, 'path': path};

  Category copyWith({int? id, String? path}) {
    return Category(id: id ?? this.id, path: path ?? this.path);
  }
}
