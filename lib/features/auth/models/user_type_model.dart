class UserTypeModel {
  final int? id;
  final String? type;
  final String? createdAt;
  final String? updatedAt;

  const UserTypeModel({this.id, this.type, this.createdAt, this.updatedAt});

  factory UserTypeModel.fromJson(Map<String, dynamic> j) => UserTypeModel(
    id: j['id'],
    type: j['type'],
    createdAt: j['created_at'],
    updatedAt: j['updated_at'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type,
    'created_at': createdAt,
    'updated_at': updatedAt,
  };

  @override
  String toString() {
    return 'UserTypeModel(id: $id, type: $type, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
