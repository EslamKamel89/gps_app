class Image {
  int? id;
  String? path;

  Image({this.id, this.path});

  @override
  String toString() => 'Image(id: $id, path: $path)';

  factory Image.fromJson(Map<String, dynamic> json) =>
      Image(id: json['id'] as int?, path: json['path'] as String?);

  Map<String, dynamic> toJson() => {'id': id, 'path': path};

  Image copyWith({int? id, String? path}) {
    return Image(id: id ?? this.id, path: path ?? this.path);
  }
}
