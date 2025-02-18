import 'package:madsm/features/post/model/post/post.dart';

class PostEditorState {
  final String content;
  final List<Media> media;
  final bool isLoading;

  PostEditorState({
    this.content = '',
    this.media = const [],
    this.isLoading = false,
  });

  PostEditorState copyWith({
    String? content,
    List<Media>? media,
    bool? isLoading,
  }) {
    return PostEditorState(
      content: content ?? this.content,
      media: media ?? this.media,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
