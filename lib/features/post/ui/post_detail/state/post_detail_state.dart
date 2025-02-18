import 'package:madsm/features/post/model/comment/comment.dart';
import 'package:madsm/features/post/model/post/post.dart';

class PostDetailState {
  final Post? post;
  final List<Comment> comments;

  PostDetailState({
    this.post,
    this.comments = const [],
  });

  PostDetailState copyWith({
    Post? post,
    List<Comment>? comments,
  }) {
    return PostDetailState(
      post: post ?? this.post,
      comments: comments ?? this.comments,
    );
  }
}
