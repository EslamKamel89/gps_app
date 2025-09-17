class OperatingTimeModel {
  List<String>? mon;
  List<String>? tue;
  List<String>? wed;
  List<String>? thu;
  List<String>? fri;
  List<String>? sat;
  List<String>? sun;

  OperatingTimeModel({this.mon, this.tue, this.wed, this.thu, this.fri, this.sat, this.sun});

  @override
  String toString() {
    return 'OperatingTimeModel(mon: $mon, tue: $tue, wed: $wed, thu: $thu, fri: $fri, sat: $sat, sun: $sun)';
  }

  factory OperatingTimeModel.fromJson(Map<String, dynamic> json) {
    return OperatingTimeModel(
      mon: json['mon'] as List<String>?,
      tue: json['tue'] as List<String>?,
      wed: json['wed'] as List<String>?,
      thu: json['thu'] as List<String>?,
      fri: json['fri'] as List<String>?,
      sat: json['sat'] as List<String>?,
      sun: json['sun'] as List<String>?,
    );
  }

  Map<String, dynamic> toJson() => {
    'mon': mon,
    'tue': tue,
    'wed': wed,
    'thu': thu,
    'fri': fri,
    'sat': sat,
    'sun': sun,
  };

  OperatingTimeModel copyWith({
    List<String>? mon,
    List<String>? tue,
    List<String>? wed,
    List<String>? thu,
    List<String>? fri,
    List<String>? sat,
    List<String>? sun,
  }) {
    return OperatingTimeModel(
      mon: mon ?? this.mon,
      tue: tue ?? this.tue,
      wed: wed ?? this.wed,
      thu: thu ?? this.thu,
      fri: fri ?? this.fri,
      sat: sat ?? this.sat,
      sun: sun ?? this.sun,
    );
  }
}
