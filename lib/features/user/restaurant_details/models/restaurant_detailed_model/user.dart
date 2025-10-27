import 'image.dart';

class User {
  String? fullName;
  String? userName;
  String? email;
  String? mobile;
  List<RestaurantImage>? images;

  User({this.fullName, this.userName, this.email, this.mobile, this.images});

  @override
  String toString() {
    return 'User(fullName: $fullName, userName: $userName, email: $email, mobile: $mobile, images: $images)';
  }

  factory User.fromJson(Map<String, dynamic> json) => User(
    fullName: json['full_name'] as String?,
    userName: json['user_name'] as String?,
    email: json['email'] as String?,
    mobile: json['mobile'] as String?,
    images:
        (json['images'] as List<dynamic>?)
            ?.map((e) => RestaurantImage.fromJson(e as Map<String, dynamic>))
            .toList(),
  );

  Map<String, dynamic> toJson() => {
    'full_name': fullName,
    'user_name': userName,
    'email': email,
    'mobile': mobile,
    'images': images?.map((e) => e.toJson()).toList(),
  };

  User copyWith({
    String? fullName,
    String? userName,
    String? email,
    String? mobile,
    List<RestaurantImage>? images,
  }) {
    return User(
      fullName: fullName ?? this.fullName,
      userName: userName ?? this.userName,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      images: images ?? this.images,
    );
  }
}
