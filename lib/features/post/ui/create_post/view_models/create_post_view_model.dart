import 'package:madsm/features/post/model/post.dart';
import 'package:madsm/features/post/repository/post_repository.dart';
import 'package:madsm/features/post/ui/create_post/view_models/post_editor_view_model.dart';
import 'package:madsm/features/profile/ui/view_models/profile_view_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'create_post_view_model.g.dart';

@riverpod
class CreatePostViewModel extends _$CreatePostViewModel {
  @override
  FutureOr<bool> build() async {
    return false;
  }

  void publishPost() async {
    state = AsyncLoading();
    try {
      final postData = ref.read(postEditorViewModelProvider).value;
      final profile = ref.read(profileViewModelProvider).value?.profile;
      if (postData == null) {
        return;
      }
      final Post post = Post(
        id: const Uuid().v4(),
        userId: profile?.id ?? '',
        content: postData.content,
        media: postData.media,
        createdAt: DateTime.now().toUtc(),
        userAvatar: profile?.avatar ?? '',
        userName: profile?.name ?? '',
      );

      await ref.read(postRepositoryProvider).publishPost(post);
      state = AsyncData(true);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}
