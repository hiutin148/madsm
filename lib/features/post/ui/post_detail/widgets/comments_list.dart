import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:madsm/constants/dimens.dart';
import 'package:madsm/features/post/model/comment/comment.dart';

import 'comment_item.dart';

class CommentsList extends ConsumerStatefulWidget {
  const CommentsList({super.key, required this.comments});

  final List<Comment> comments;

  @override
  ConsumerState createState() => _CommentsListState();
}

class _CommentsListState extends ConsumerState<CommentsList> {
  @override
  Widget build(BuildContext context) {
    return widget.comments.isNotEmpty
        ? ListView.separated(
            padding: EdgeInsets.all(
              Dimens.padding,
            ),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.comments.length,
            itemBuilder: (context, index) {
              return CommentItem(comment: widget.comments[index]);
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(
                height: 20,
              );
            },
          )
        : Container();
  }
}
