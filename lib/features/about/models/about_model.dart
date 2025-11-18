class AboutModel {
  int? id;
  String? title;
  String? content;
  String? image;

  AboutModel({this.id, this.title, this.content, this.image});

  @override
  String toString() {
    return 'AboutModel(id: $id, title: $title, content: $content, image: $image)';
  }

  factory AboutModel.fromJson(Map<String, dynamic> json) => AboutModel(
    id: json['id'] as int?,
    title: json['title'] as String?,
    content: json['content'] as String?,
    image: json['image'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'content': content,
    'image': image,
  };
}
