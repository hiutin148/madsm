import 'package:madsm/features/post/model/post/post.dart';
import 'package:madsm/features/post/repository/post_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'new_feed_view_model.g.dart';

@Riverpod()
class NewFeedViewModel extends _$NewFeedViewModel {
  @override
  FutureOr<List<Post>> build() async {
    final posts = await ref.read(postRepositoryProvider).fetchPost();
    return posts;
  }

  void refreshNewFeed() async {
    state = AsyncLoading();
    try {
      final posts = await ref.read(postRepositoryProvider).fetchPost();
      state = AsyncData(posts);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}
