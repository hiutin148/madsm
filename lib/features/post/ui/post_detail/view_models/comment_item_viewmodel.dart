import 'package:madsm/features/post/model/comment/comment.dart';
import 'package:madsm/features/post/repository/post_repository.dart';
import 'package:madsm/features/profile/ui/view_models/profile_view_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'comment_item_viewmodel.g.dart';

@riverpod
class CommentItemViewModel extends _$CommentItemViewModel {
  @override
  FutureOr<Comment?> build({Comment? comment}) async {
    return comment;
  }

  Future<bool> toggleLikeComment({
    required String commentId,
    required bool isLiked,
  }) async {
    try {
      final userId = ref.read(profileViewModelProvider).value?.profile?.id ?? '';
      if (isLiked) {
        final comment = await ref.read(postRepositoryProvider).unlikeComment(commentId: commentId, userId: userId);
        state = AsyncData(comment);
        return false;
      } else {
        final comment = await ref.read(postRepositoryProvider).likeComment(commentId: commentId, userId: userId);
        state = AsyncData(comment);
        return true;
      }
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      return isLiked;
    }
  }
}
