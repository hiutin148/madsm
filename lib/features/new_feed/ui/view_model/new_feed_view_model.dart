import 'package:madsm/features/post/model/post.dart';
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
}
