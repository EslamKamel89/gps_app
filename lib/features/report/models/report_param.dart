import 'package:gps_app/core/helpers/user.dart';

class ReportParam {
  int? typeId;
  String? type;
  String? description;
  String? option;

  ReportParam({this.typeId, this.type, this.description, this.option});

  @override
  String toString() {
    return 'ReportParam(typeId: $typeId, type: $type, description: $description, option: $option)';
  }

  factory ReportParam.fromJson(Map<String, dynamic> json) => ReportParam(
    typeId: json['type_id'] as int?,
    type: json['type'] as String?,
    description: json['description'] as String?,
    option: json['option'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'type_id': typeId,
    'type': type,
    'description': option == 'Other' ? description : null,
    'option': option,
    "user_id": userInMemory()?.id,
  };

  ReportParam copyWith({
    int? typeId,
    String? type,
    String? description,
    String? option,
  }) {
    return ReportParam(
      typeId: typeId ?? this.typeId,
      type: type ?? this.type,
      description: description ?? this.description,
      option: option ?? this.option,
    );
  }
}
