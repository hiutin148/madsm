import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:madsm/extensions/build_context_extension.dart';
import 'package:madsm/extensions/text_style_extension.dart';
import 'package:madsm/features/common/ui/widgets/common_like_button.dart';
import 'package:madsm/features/post/model/comment/comment.dart';
import 'package:madsm/features/post/ui/post_detail/view_models/comment_item_viewmodel.dart';
import 'package:madsm/features/profile/ui/view_models/profile_view_model.dart';
import 'package:madsm/utils/utils.dart';

typedef LikeCommentCallback = bool Function();

class CommentItem extends ConsumerStatefulWidget {
  const CommentItem({
    super.key,
    required this.comment,
  });

  final Comment comment;

  @override
  ConsumerState<CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends ConsumerState<CommentItem> {
  late bool isLiked;

  @override
  void initState() {
    super.initState();
    final userId = ref.read(profileViewModelProvider).value?.profile?.id ?? '';
    isLiked = widget.comment.likedBy.contains(userId);
  }

  @override
  Widget build(BuildContext context) {
    final comment = ref.watch(commentItemViewModelProvider(comment: widget.comment)).value;
    return comment == null
        ? Container()
        : Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            CircleAvatar(
              radius: 16,
              foregroundImage: NetworkImage(comment.userAvatar),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                spacing: 4,
                children: [
                  Text(
                    comment.userName,
                    style: context.textTheme.bodyMedium?.w700,
                  ),
                  Text(
                    comment.content,
                    style: context.textTheme.bodyMedium,
                    maxLines: null,
                  ),
                  RichText(
                    text: TextSpan(
                      style: context.textTheme.bodySmall?.lighterGrey,
                      children: [
                        TextSpan(
                          text: Utils.calculateTimeDifference(
                            comment.createdAt,
                          ),
                        ),
                        if (comment.likeCount > 0) ...{
                          TextSpan(text: " • "),
                          TextSpan(text: '${comment.likeCount} likes'),
                        }
                      ],
                    ),
                  ),
                ],
              ),
            ),
            CommonLikeButton(
              isLiked: isLiked,
              onTap: () async {
                setState(() {
                  isLiked = !isLiked;
                });
                final result = await ref.read(commentItemViewModelProvider(comment: widget.comment).notifier).toggleLikeComment(
                      commentId: comment.id ?? '',
                      isLiked: !isLiked,
                    );
                setState(() {
                  isLiked = result;
                });
              },
            ),
          ],
        );
  }
}
