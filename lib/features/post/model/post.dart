import 'package:freezed_annotation/freezed_annotation.dart';

part 'post.freezed.dart';

part 'post.g.dart';

@freezed
class Post with _$Post {
  factory Post({
    String? id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'user_avatar') required String userAvatar,
    @JsonKey(name: 'user_name') required String userName,
    required String content,
    required List<Media> media,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(name: 'like_count') @Default(0) int likeCount,
    @JsonKey(name: 'comment_count') @Default(0) int commentCount,
    @JsonKey(name: 'liked_by') @Default([]) List<String> likedBy,
  }) = _Post;

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
}

@freezed
class Media with _$Media {
  factory Media({
    required String url,
    String? path,
    required MediaType type,
  }) = _Media;

  factory Media.fromJson(Map<String, dynamic> json) => _$MediaFromJson(json);
}

enum MediaType { image, gif, file, video }
