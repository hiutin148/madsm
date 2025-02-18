import 'package:madsm/features/new_feed/ui/view_model/new_feed_item_view_model.dart';
import 'package:madsm/features/new_feed/ui/view_model/new_feed_view_model.dart';
import 'package:madsm/features/post/model/comment/comment.dart';
import 'package:madsm/features/post/model/post/post.dart';
import 'package:madsm/features/post/repository/post_repository.dart';
import 'package:madsm/features/post/ui/post_detail/state/post_detail_state.dart';
import 'package:madsm/features/profile/ui/view_models/profile_view_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'post_detail_view_model.g.dart';

@riverpod
class PostDetailViewModel extends _$PostDetailViewModel {
  @override
  FutureOr<PostDetailState> build({Post? initPost}) async {
    final comments = await ref.read(postRepositoryProvider).getPostComments(initPost?.id ?? '');
    final post = await ref.read(postRepositoryProvider).getPostById(initPost?.id ?? '');
    return PostDetailState(post: post, comments: comments);
  }

  void sendComment(
    String postId,
    String content,
  ) {
    try {
      final profile = ref.read(profileViewModelProvider).value?.profile;
      final Comment comment = Comment(
        id: const Uuid().v4(),
        postId: postId,
        userId: profile?.id ?? '',
        userAvatar: profile?.avatar ?? '',
        userName: profile?.username ?? '',
        content: content,
        createdAt: DateTime.now().toUtc(),
      );
      ref.read(postRepositoryProvider).sendComment(comment);

      state = AsyncData(
        state.value!.copyWith(
          comments: [comment, ...state.value!.comments],
          post: state.value?.post?.copyWith(commentCount: (state.value?.post?.commentCount ?? 0) + 1),
        ),
      );
      if ((ref.read(newFeedViewModelProvider).value ?? []).any((post) => post.id == postId)) {
        ref
            .read(newFeedItemViewModelProvider((ref.read(newFeedViewModelProvider).value ?? []).firstWhere(
              (post) => post.id == postId,
            )).notifier)
            .refreshPost();
      }
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}
