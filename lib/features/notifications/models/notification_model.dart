class NotificationModel {
  int? id;
  String? path;
  String? content;
  int? pathId;
  String? createdAt;
  int? deviceId;
  int? isRead;
  int? userId;
  String? accessToken;

  NotificationModel({
    this.id,
    this.path,
    this.content,
    this.pathId,
    this.createdAt,
    this.deviceId,
    this.isRead,
    this.userId,
    this.accessToken,
  });

  @override
  String toString() {
    return 'NotificationModel(id: $id, path: $path, content: $content, pathId: $pathId, createdAt: $createdAt, deviceId: $deviceId, isRead: $isRead, userId: $userId, accessToken: $accessToken)';
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    int? toInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is String && value.trim().isNotEmpty) {
        return int.tryParse(value.trim());
      }
      return null;
    }

    return NotificationModel(
      id: toInt(json['id']),
      path: json['path'] as String?,
      content: json['content'] as String?,
      pathId: toInt(json['path_id']),
      createdAt: json['created_at'] as String?,
      deviceId: toInt(json['device_id']),
      isRead: toInt(json['is_read']),
      userId: toInt(json['user_id']),
      accessToken: json['access_token'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'path': path,
    'content': content,
    'path_id': pathId,
    'created_at': createdAt,
    'device_id': deviceId,
    'is_read': isRead,
    'user_id': userId,
    'access_token': accessToken,
  };

  NotificationModel copyWith({
    int? id,
    String? path,
    String? content,
    int? pathId,
    String? createdAt,
    int? deviceId,
    int? isRead,
    int? userId,
    String? accessToken,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      path: path ?? this.path,
      content: content ?? this.content,
      pathId: pathId ?? this.pathId,
      createdAt: createdAt ?? this.createdAt,
      deviceId: deviceId ?? this.deviceId,
      isRead: isRead ?? this.isRead,
      userId: userId ?? this.userId,
      accessToken: accessToken ?? this.accessToken,
    );
  }
}
