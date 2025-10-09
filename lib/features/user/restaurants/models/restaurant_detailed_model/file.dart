class File {
  String? path;

  File({this.path});

  @override
  String toString() => 'File(path: $path)';

  factory File.fromJson(Map<String, dynamic> json) =>
      File(path: json['path'] as String?);

  Map<String, dynamic> toJson() => {'path': path};

  File copyWith({String? path}) {
    return File(path: path ?? this.path);
  }
}
