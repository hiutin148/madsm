import 'package:madsm/features/new_feed/ui/state/new_feed_item_state.dart';
import 'package:madsm/features/post/model/post.dart';
import 'package:madsm/features/post/repository/post_repository.dart';
import 'package:madsm/features/profile/ui/view_models/profile_view_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'new_feed_item_view_model.g.dart';

@Riverpod()
class NewFeedItemViewModel extends _$NewFeedItemViewModel {
  @override
  FutureOr<NewFeedItemState> build(Post post) async {
    return NewFeedItemState(
      post: post,
      isLiked: isLikedByCurrentUser(post),
    );
  }

  bool isLikedByCurrentUser(Post post) {
    final userId = ref.read(profileViewModelProvider).value?.profile?.id ?? '';
    return post.likedBy.contains(userId);
  }

  void toggleLike() {
    if (state.value!.isLiked) {
      unlikePost();
    } else {
      likePost();
    }
  }

  void likePost() async {
    state = AsyncData(state.value!.copyWith(isLiked: true));
    try {
      final userId = ref.read(profileViewModelProvider).value?.profile?.id ?? '';
      final post = await ref.read(postRepositoryProvider).likePost(
            postId: state.value?.post.id ?? '',
            userId: userId,
          );
      state = AsyncData(state.value!.copyWith(post: post));
    } catch (e) {
      state = AsyncData(state.value!.copyWith(isLiked: false));
    }
  }

  void unlikePost() async {
    state = AsyncData(state.value!.copyWith(isLiked: false));

    try {
      final userId = ref.read(profileViewModelProvider).value?.profile?.id ?? '';
      final post = await ref.read(postRepositoryProvider).unlikePost(
            postId: state.value?.post.id ?? '',
            userId: userId,
          );
      state = AsyncData(state.value!.copyWith(post: post));
    } catch (e) {
      state = AsyncData(state.value!.copyWith(isLiked: true));
    }
  }
}
