class HolidayModel {
  int? id;
  String? name;
  int? year;
  DateTime? date;
  bool? isFederal;
  dynamic notes;
  DateTime? createdAt;
  DateTime? updatedAt;

  HolidayModel({
    this.id,
    this.name,
    this.year,
    this.date,
    this.isFederal,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });

  @override
  String toString() {
    return 'HolidayModel(id: $id, name: $name, year: $year, date: $date, isFederal: $isFederal, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  factory HolidayModel.fromJson(Map<String, dynamic> json) => HolidayModel(
    id: json['id'] as int?,
    name: json['name'] as String?,
    year: json['year'] as int?,
    date: json['date'] == null ? null : DateTime.parse(json['date'] as String),
    isFederal: json['is_federal'] as bool?,
    notes: json['notes'] as dynamic,
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
    'name': name,
    'year': year,
    'date': date?.toIso8601String(),
    'is_federal': isFederal,
    'notes': notes,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };

  HolidayModel copyWith({
    int? id,
    String? name,
    int? year,
    DateTime? date,
    bool? isFederal,
    dynamic notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return HolidayModel(
      id: id ?? this.id,
      name: name ?? this.name,
      year: year ?? this.year,
      date: date ?? this.date,
      isFederal: isFederal ?? this.isFederal,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
