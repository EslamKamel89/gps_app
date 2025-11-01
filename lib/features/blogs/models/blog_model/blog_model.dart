import 'comment.dart';
import 'image.dart';

class BlogModel {
  int? id;
  String? title;
  String? content;
  int? mediaId;
  String? link;
  String? type;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? likesCount;
  int? commentsCount;
  List<Comment>? comments;
  Image? image;

  BlogModel({
    this.id,
    this.title,
    this.content,
    this.mediaId,
    this.link,
    this.type,
    this.createdAt,
    this.updatedAt,
    this.likesCount,
    this.commentsCount,
    this.comments,
    this.image,
  });

  @override
  String toString() {
    return 'BlogModel(id: $id, title: $title, content: $content, mediaId: $mediaId, link: $link, type: $type, createdAt: $createdAt, updatedAt: $updatedAt, likesCount: $likesCount, commentsCount: $commentsCount, comments: $comments, image: $image)';
  }

  factory BlogModel.fromJson(Map<String, dynamic> json) => BlogModel(
    id: json['id'] as int?,
    title: json['title'] as String?,
    content: json['content'] as String?,
    mediaId: json['media_id'] as int?,
    link: json['link'] as String?,
    type: json['type'] as String?,
    createdAt:
        json['created_at'] == null
            ? null
            : DateTime.parse(json['created_at'] as String),
    updatedAt:
        json['updated_at'] == null
            ? null
            : DateTime.parse(json['updated_at'] as String),
    likesCount: json['likes_count'] as int?,
    commentsCount: json['comments_count'] as int?,
    comments:
        (json['comments'] as List<dynamic>?)
            ?.map((e) => Comment.fromJson(e as Map<String, dynamic>))
            .toList(),
    image:
        json['image'] == null
            ? null
            : Image.fromJson(json['image'] as Map<String, dynamic>),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'content': content,
    'media_id': mediaId,
    'link': link,
    'type': type,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
    'likes_count': likesCount,
    'comments_count': commentsCount,
    'comments': comments?.map((e) => e.toJson()).toList(),
    'image': image?.toJson(),
  };

  BlogModel copyWith({
    int? id,
    String? title,
    String? content,
    int? mediaId,
    String? link,
    String? type,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? likesCount,
    int? commentsCount,
    List<Comment>? comments,
    Image? image,
  }) {
    return BlogModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      mediaId: mediaId ?? this.mediaId,
      link: link ?? this.link,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      comments: comments ?? this.comments,
      image: image ?? this.image,
    );
  }
}
