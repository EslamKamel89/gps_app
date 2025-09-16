class UserRegisterParam {
  String? fullName;
  String? userName;
  String? email;
  String? mobile;
  String? password;
  int? stateId;
  int? districtId;
  int? imageId;

  UserRegisterParam({
    this.fullName,
    this.userName,
    this.email,
    this.mobile,
    this.password,
    this.stateId,
    this.districtId,
    this.imageId,
  });

  @override
  String toString() {
    return 'UserRegisterParam(fullName: $fullName, userName: $userName, email: $email, mobile: $mobile, password: $password, stateId: $stateId, districtId: $districtId, imageId: $imageId)';
  }

  factory UserRegisterParam.fromJson(Map<String, dynamic> json) {
    return UserRegisterParam(
      fullName: json['full_name'] as String?,
      userName: json['user_name'] as String?,
      email: json['email'] as String?,
      mobile: json['mobile'] as String?,
      password: json['password'] as String?,
      stateId: json['state_id'] as int?,
      districtId: json['district_id'] as int?,
      imageId: json['image_id'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'full_name': fullName,
    'user_name': userName,
    'email': email,
    'mobile': mobile,
    'password': password,
    'state_id': stateId,
    'district_id': districtId,
    'image_id': imageId,
  };

  UserRegisterParam copyWith({
    String? fullName,
    String? userName,
    String? email,
    String? mobile,
    String? password,
    int? stateId,
    int? districtId,
    int? imageId,
  }) {
    return UserRegisterParam(
      fullName: fullName ?? this.fullName,
      userName: userName ?? this.userName,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      password: password ?? this.password,
      stateId: stateId ?? this.stateId,
      districtId: districtId ?? this.districtId,
      imageId: imageId ?? this.imageId,
    );
  }
}
