class User {
	int? id;
	String? fullName;
	String? userName;
	String? email;
	DateTime? emailVerifiedAt;
	String? mobile;
	int? userTypeId;
	int? districtId;
	int? stateId;

	User({
		this.id, 
		this.fullName, 
		this.userName, 
		this.email, 
		this.emailVerifiedAt, 
		this.mobile, 
		this.userTypeId, 
		this.districtId, 
		this.stateId, 
	});

	@override
	String toString() {
		return 'User(id: $id, fullName: $fullName, userName: $userName, email: $email, emailVerifiedAt: $emailVerifiedAt, mobile: $mobile, userTypeId: $userTypeId, districtId: $districtId, stateId: $stateId)';
	}

	factory User.fromJson(Map<String, dynamic> json) => User(
				id: json['id'] as int?,
				fullName: json['full_name'] as String?,
				userName: json['user_name'] as String?,
				email: json['email'] as String?,
				emailVerifiedAt: json['email_verified_at'] == null
						? null
						: DateTime.parse(json['email_verified_at'] as String),
				mobile: json['mobile'] as String?,
				userTypeId: json['user_type_id'] as int?,
				districtId: json['district_id'] as int?,
				stateId: json['state_id'] as int?,
			);

	Map<String, dynamic> toJson() => {
				'id': id,
				'full_name': fullName,
				'user_name': userName,
				'email': email,
				'email_verified_at': emailVerifiedAt?.toIso8601String(),
				'mobile': mobile,
				'user_type_id': userTypeId,
				'district_id': districtId,
				'state_id': stateId,
			};
}
