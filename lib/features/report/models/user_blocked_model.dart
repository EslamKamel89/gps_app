class UserBlockedModel {
  int? id;
  int? userId;
  int? blockedUserId;
  String? reason;

  UserBlockedModel({this.id, this.userId, this.blockedUserId, this.reason});

  @override
  String toString() {
    return 'UserBlockedModel(id: $id, userId: $userId, blockedUserId: $blockedUserId, reason: $reason)';
  }

  factory UserBlockedModel.fromJson(Map<String, dynamic> json) {
    return UserBlockedModel(
      id: json['id'] as int?,
      userId: json['user_id'] as int?,
      blockedUserId: json['blocked_user_id'] as int?,
      reason: json['reason'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'blocked_user_id': blockedUserId,
    'reason': reason,
  };
}
