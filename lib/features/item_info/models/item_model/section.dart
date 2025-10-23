class Section {
  int? id;
  int? userId;
  int? vendorId;
  dynamic farmId;
  int? storeId;
  String? name;
  bool? status;
  int? position;

  Section({
    this.id,
    this.userId,
    this.vendorId,
    this.farmId,
    this.storeId,
    this.name,
    this.status,
    this.position,
  });

  @override
  String toString() {
    return 'Section(id: $id, userId: $userId, vendorId: $vendorId, farmId: $farmId, storeId: $storeId, name: $name, status: $status, position: $position)';
  }

  factory Section.fromJson(Map<String, dynamic> json) => Section(
    id: json['id'] as int?,
    userId: json['user_id'] as int?,
    vendorId: json['vendor_id'] as int?,
    farmId: json['farm_id'] as dynamic,
    storeId: json['store_id'] as int?,
    name: json['name'] as String?,
    status: json['status'] as bool?,
    position: json['position'] as int?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'vendor_id': vendorId,
    'farm_id': farmId,
    'store_id': storeId,
    'name': name,
    'status': status,
    'position': position,
  };

  Section copyWith({
    int? id,
    int? userId,
    int? vendorId,
    dynamic farmId,
    int? storeId,
    String? name,
    bool? status,
    int? position,
  }) {
    return Section(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      vendorId: vendorId ?? this.vendorId,
      farmId: farmId ?? this.farmId,
      storeId: storeId ?? this.storeId,
      name: name ?? this.name,
      status: status ?? this.status,
      position: position ?? this.position,
    );
  }
}
