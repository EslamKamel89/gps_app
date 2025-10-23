class Image {
  int? id;
  String? path;
  String? imageableType;
  int? imageableId;

  Image({this.id, this.path, this.imageableType, this.imageableId});

  @override
  String toString() {
    return 'Image(id: $id, path: $path, imageableType: $imageableType, imageableId: $imageableId)';
  }

  factory Image.fromJson(Map<String, dynamic> json) => Image(
    id: json['id'] as int?,
    path: json['path'] as String?,
    imageableType: json['imageable_type'] as String?,
    imageableId: json['imageable_id'] as int?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'path': path,
    'imageable_type': imageableType,
    'imageable_id': imageableId,
  };

  Image copyWith({
    int? id,
    String? path,
    String? imageableType,
    int? imageableId,
  }) {
    return Image(
      id: id ?? this.id,
      path: path ?? this.path,
      imageableType: imageableType ?? this.imageableType,
      imageableId: imageableId ?? this.imageableId,
    );
  }
}
