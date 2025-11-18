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
    return NotificationModel(
      id: json['id'] as int?,
      path: json['path'] as String?,
      content: json['content'] as String?,
      pathId: json['path_id'] as int?,
      createdAt: json['created_at'] as String?,
      deviceId: json['device_id'] as int?,
      isRead: json['is_read'] as int?,
      userId: json['user_id'] as int?,
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
