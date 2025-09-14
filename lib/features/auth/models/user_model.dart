import 'user_type_model.dart';

class UserModel {
  final int? id;
  final String? fullName;
  final String? userName;
  final String? email;
  final String? emailVerifiedAt;
  final String? mobile;
  final String? createdAt;
  final String? updatedAt;
  final int? userTypeId;
  final int? districtId;
  final int? stateId;
  final String? token;
  final UserTypeModel? userType;

  const UserModel({
    this.id,
    this.fullName,
    this.userName,
    this.email,
    this.emailVerifiedAt,
    this.mobile,
    this.createdAt,
    this.updatedAt,
    this.userTypeId,
    this.districtId,
    this.stateId,
    this.token,
    this.userType,
  });

  factory UserModel.fromJson(Map<String, dynamic> j) => UserModel(
    id: j['id'],
    fullName: j['full_name'],
    userName: j['user_name'],
    email: j['email'],
    emailVerifiedAt: j['email_verified_at'],
    mobile: j['mobile'],
    createdAt: j['created_at'],
    updatedAt: j['updated_at'],
    userTypeId: j['user_type_id'],
    districtId: j['district_id'],
    stateId: j['state_id'],
    token: j['token'],
    userType: j['user_type'] == null ? null : UserTypeModel.fromJson(j['user_type']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'full_name': fullName,
    'user_name': userName,
    'email': email,
    'email_verified_at': emailVerifiedAt,
    'mobile': mobile,
    'created_at': createdAt,
    'updated_at': updatedAt,
    'user_type_id': userTypeId,
    'district_id': districtId,
    'state_id': stateId,
    'token': token,
    'user_type': userType?.toJson(),
  };
}
