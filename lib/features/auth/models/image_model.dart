class ImageModel {
  int? id;
  String? path;
  String? imageableType;
  int? imageableId;
  DateTime? createdAt;
  DateTime? updatedAt;

  ImageModel({
    this.id,
    this.path,
    this.imageableType,
    this.imageableId,
    this.createdAt,
    this.updatedAt,
  });

  @override
  String toString() {
    return 'ImageModel(id: $id, path: $path, imageableType: $imageableType, imageableId: $imageableId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  factory ImageModel.fromJson(Map<String, dynamic> json) => ImageModel(
    id: json['id'] as int?,
    path: json['path'] as String?,
    imageableType: json['imageable_type'] as String?,
    imageableId: json['imageable_id'] as int?,
    createdAt:
        json['created_at'] == null
            ? null
            : DateTime.parse(json['created_at'] as String),
    updatedAt:
        json['updated_at'] == null
            ? null
            : DateTime.parse(json['updated_at'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'path': path,
    'imageable_type': imageableType,
    'imageable_id': imageableId,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };

  ImageModel copyWith({
    int? id,
    String? path,
    String? imageableType,
    int? imageableId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ImageModel(
      id: id ?? this.id,
      path: path ?? this.path,
      imageableType: imageableType ?? this.imageableType,
      imageableId: imageableId ?? this.imageableId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
