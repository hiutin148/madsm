import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:madsm/constants/dimens.dart';
import 'package:madsm/features/common/ui/widgets/common_error.dart';
import 'package:madsm/features/common/ui/widgets/shimmer_post_item.dart';
import 'package:madsm/features/new_feed/ui/widgets/new_feed_item.dart';
import 'package:madsm/features/post/model/post/post.dart';
import 'package:madsm/features/post/ui/post_detail/widgets/comments_list.dart';
import 'package:madsm/theme/app_colors.dart';

import 'view_models/post_detail_view_model.dart';

class PostDetailScreen extends ConsumerStatefulWidget {
  const PostDetailScreen({super.key, required this.post});

  final Post post;

  @override
  ConsumerState<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends ConsumerState<PostDetailScreen> {
  final commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.post.userName}\'s post'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          return ref.refresh(postDetailViewModelProvider(initPost: widget.post).future);
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildPostSection(),
              buildCommentsList(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: buildSendCommentSection(),
    );
  }

  Widget buildSendCommentSection() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          color: AppColors.lighterGrey.withValues(alpha: 0.4),
          blurRadius: 4,
          offset: Offset(0, 2),
        ),
      ]),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom,
        left: Dimens.padding,
        right: Dimens.padding,
      ),
      // height: kBottomNavigationBarHeight,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: commentController,
              decoration: InputDecoration(
                hintText: 'Write a comment...',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              if (commentController.text.isEmpty) return;
              ref.read(postDetailViewModelProvider(initPost: widget.post).notifier).sendComment(
                    widget.post.id ?? '',
                    commentController.text,
                  );
              commentController.clear();
            },
          ),
        ],
      ),
    );
  }

  Widget buildPostSection() {
    final postDetailState = ref.watch(postDetailViewModelProvider(initPost: widget.post));
    if (postDetailState is AsyncData && postDetailState.value?.post != null) {
      return NewFeedItem(
        post: postDetailState.value!.post!,
        isDetail: true,
      );
    } else if (postDetailState is AsyncLoading) {
      return ShimmerPostItem();
    } else {
      return CommonError();
    }
  }

  Widget buildCommentsList() {
    final postDetailState = ref.watch(postDetailViewModelProvider(initPost: widget.post));
    if (postDetailState is AsyncData && postDetailState.value?.comments != null) {
      if (postDetailState.value!.comments.isEmpty) {
        return Center(
          child: Text('No comments yet'),
        );
      }
      return CommentsList(
        comments: postDetailState.value!.comments,
      );
    } else if (postDetailState is AsyncLoading) {
      return ShimmerPostItem();
    } else {
      return CommonError();
    }
  }
}
