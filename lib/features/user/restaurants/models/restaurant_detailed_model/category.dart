class Category {
  int? id;
  String? name;

  Category({this.id, this.name});

  @override
  String toString() => 'Category(id: $id, name: $name)';

  factory Category.fromJson(Map<String, dynamic> json) =>
      Category(id: json['id'] as int?, name: json['name'] as String?);

  Map<String, dynamic> toJson() => {'id': id, 'name': name};

  Category copyWith({int? id, String? name}) {
    return Category(id: id ?? this.id, name: name ?? this.name);
  }
}
