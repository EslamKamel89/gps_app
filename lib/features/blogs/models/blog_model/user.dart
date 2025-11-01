class User {
  int? id;
  String? fullName;
  String? userName;
  String? email;
  String? mobile;

  User({this.id, this.fullName, this.userName, this.email, this.mobile});

  @override
  String toString() {
    return 'User(id: $id, fullName: $fullName, userName: $userName, email: $email, mobile: $mobile)';
  }

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'] as int?,
    fullName: json['full_name'] as String?,
    userName: json['user_name'] as String?,
    email: json['email'] as String?,
    mobile: json['mobile'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'full_name': fullName,
    'user_name': userName,
    'email': email,
    'mobile': mobile,
  };

  User copyWith({
    int? id,
    String? fullName,
    String? userName,
    String? email,
    String? mobile,
  }) {
    return User(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      userName: userName ?? this.userName,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
    );
  }
}
