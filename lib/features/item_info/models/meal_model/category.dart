class Category {
  int? id;
  String? name;
  String? description;

  Category({this.id, this.name, this.description});

  @override
  String toString() {
    return 'Category(id: $id, name: $name, description: $description)';
  }

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json['id'] as int?,
    name: json['name'] as String?,
    description: json['description'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
  };

  Category copyWith({int? id, String? name, String? description}) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }
}
