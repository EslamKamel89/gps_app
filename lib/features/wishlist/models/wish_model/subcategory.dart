class Subcategory {
	int? id;
	int? categoryId;
	String? name;
	String? description;

	Subcategory({this.id, this.categoryId, this.name, this.description});

	@override
	String toString() {
		return 'Subcategory(id: $id, categoryId: $categoryId, name: $name, description: $description)';
	}

	factory Subcategory.fromJson(Map<String, dynamic> json) => Subcategory(
				id: json['id'] as int?,
				categoryId: json['category_id'] as int?,
				name: json['name'] as String?,
				description: json['description'] as String?,
			);

	Map<String, dynamic> toJson() => {
				'id': id,
				'category_id': categoryId,
				'name': name,
				'description': description,
			};
}
