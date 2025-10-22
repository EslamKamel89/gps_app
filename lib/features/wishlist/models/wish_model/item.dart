class Item {
	int? id;
	int? userId;
	int? vendorId;
	dynamic farmId;
	int? storeId;
	int? catalogSectionId;
	String? name;
	String? price;
	String? description;
	bool? status;
	int? position;

	Item({
		this.id, 
		this.userId, 
		this.vendorId, 
		this.farmId, 
		this.storeId, 
		this.catalogSectionId, 
		this.name, 
		this.price, 
		this.description, 
		this.status, 
		this.position, 
	});

	@override
	String toString() {
		return 'Item(id: $id, userId: $userId, vendorId: $vendorId, farmId: $farmId, storeId: $storeId, catalogSectionId: $catalogSectionId, name: $name, price: $price, description: $description, status: $status, position: $position)';
	}

	factory Item.fromJson(Map<String, dynamic> json) => Item(
				id: json['id'] as int?,
				userId: json['user_id'] as int?,
				vendorId: json['vendor_id'] as int?,
				farmId: json['farm_id'] as dynamic,
				storeId: json['store_id'] as int?,
				catalogSectionId: json['catalog_section_id'] as int?,
				name: json['name'] as String?,
				price: json['price'] as String?,
				description: json['description'] as String?,
				status: json['status'] as bool?,
				position: json['position'] as int?,
			);

	Map<String, dynamic> toJson() => {
				'id': id,
				'user_id': userId,
				'vendor_id': vendorId,
				'farm_id': farmId,
				'store_id': storeId,
				'catalog_section_id': catalogSectionId,
				'name': name,
				'price': price,
				'description': description,
				'status': status,
				'position': position,
			};
}
