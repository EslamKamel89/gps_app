// ignore_for_file: public_member_api_docs, sort_constructors_first

class UploadedImage {
  final int id;
  final String path;

  const UploadedImage({required this.id, required this.path});

  factory UploadedImage.fromJson(Map<String, dynamic> json) {
    return UploadedImage(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      path: json['path'] as String,
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'path': path};

  @override
  String toString() => 'UploadedImage(id: $id, path: $path)';
}

enum UploadResource {
  category,
  subcategory,
  restaurant,
  vendor,
  branch,
  user,
  common;

  String get dir => name;
}
