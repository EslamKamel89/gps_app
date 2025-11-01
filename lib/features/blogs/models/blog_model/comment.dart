import 'user.dart';

class Comment {
  int? id;
  int? blogId;
  int? userId;
  String? type;
  String? comment;
  DateTime? createdAt;
  DateTime? updatedAt;
  User? user;

  Comment({
    this.id,
    this.blogId,
    this.userId,
    this.type,
    this.comment,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  @override
  String toString() {
    return 'Comment(id: $id, blogId: $blogId, userId: $userId, type: $type, comment: $comment, createdAt: $createdAt, updatedAt: $updatedAt, user: $user)';
  }

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    id: json['id'] as int?,
    blogId: json['blog_id'] as int?,
    userId: json['user_id'] as int?,
    type: json['type'] as String?,
    comment: json['comment'] as String?,
    createdAt:
        json['created_at'] == null
            ? null
            : DateTime.parse(json['created_at'] as String),
    updatedAt:
        json['updated_at'] == null
            ? null
            : DateTime.parse(json['updated_at'] as String),
    user:
        json['user'] == null
            ? null
            : User.fromJson(json['user'] as Map<String, dynamic>),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'blog_id': blogId,
    'user_id': userId,
    'type': type,
    'comment': comment,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
    'user': user?.toJson(),
  };

  Comment copyWith({
    int? id,
    int? blogId,
    int? userId,
    String? type,
    String? comment,
    DateTime? createdAt,
    DateTime? updatedAt,
    User? user,
  }) {
    return Comment(
      id: id ?? this.id,
      blogId: blogId ?? this.blogId,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      user: user ?? this.user,
    );
  }
}
