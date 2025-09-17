class PriceRange {
  int? max;
  int? min;

  PriceRange({this.max, this.min});

  @override
  String toString() => 'PriceRange(max: $max, min: $min)';

  factory PriceRange.fromJson(Map<String, dynamic> json) =>
      PriceRange(max: json['max'] as int?, min: json['min'] as int?);

  Map<String, dynamic> toJson() => {'max': max, 'min': min};

  PriceRange copyWith({int? max, int? min}) {
    return PriceRange(max: max ?? this.max, min: min ?? this.min);
  }
}
