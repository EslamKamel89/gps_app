import 'package:gps_app/features/auth/models/state_model.dart';

class DistrictModel {
  int? id;
  String? name;
  int? stateId;
  StateModel? state;

  DistrictModel({this.id, this.name, this.stateId, this.state});

  @override
  String toString() {
    return 'DistrictModel(id: $id, name: $name, stateId: $stateId, state: $state)';
  }

  factory DistrictModel.fromJson(Map<String, dynamic> json) => DistrictModel(
    id: json['id'] as int?,
    name: json['name'] as String?,
    stateId: json['state_id'] as int?,
    state:
        json['state'] == null
            ? null
            : StateModel.fromJson(json['state'] as Map<String, dynamic>),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'state_id': stateId,
    'state': state?.toJson(),
  };
}
