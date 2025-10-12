import 'package:gps_app/core/helpers/to_string_list.dart';

class OperatingHours {
  List<String>? mon;
  List<String>? tue;
  List<String>? wed;
  List<String>? thu;
  List<String>? fri;
  List<String>? sat;
  List<String>? sun;

  OperatingHours({
    this.mon,
    this.tue,
    this.wed,
    this.thu,
    this.fri,
    this.sat,
    this.sun,
  });

  @override
  String toString() {
    return 'OperatingHours(mon: $mon, tue: $tue, wed: $wed, thu: $thu, fri: $fri, sat: $sat, sun: $sun)';
  }

  factory OperatingHours.fromJson(Map<String, dynamic> json) {
    return OperatingHours(
      mon: toStringList(json['mon']),
      tue: toStringList(json['tue']),
      wed: toStringList(json['wed']),
      thu: toStringList(json['thu']),
      fri: toStringList(json['fri']),
      sat: toStringList(json['sat']),
      sun: toStringList(json['sun']),
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

  OperatingHours copyWith({
    List<String>? mon,
    List<String>? tue,
    List<String>? wed,
    List<String>? thu,
    List<String>? fri,
    List<String>? sat,
    List<String>? sun,
  }) {
    return OperatingHours(
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
