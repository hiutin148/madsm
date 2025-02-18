import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:madsm/constants/assets.dart';
import 'package:madsm/constants/dimens.dart';
import 'package:madsm/extensions/build_context_extension.dart';
import 'package:madsm/extensions/text_style_extension.dart';
import 'package:madsm/features/common/ui/widgets/common_cached_image.dart';
import 'package:madsm/features/common/ui/widgets/common_like_button.dart';
import 'package:madsm/features/common/ui/widgets/common_svg_picture.dart';
import 'package:madsm/features/new_feed/ui/view_model/new_feed_item_view_model.dart';
import 'package:madsm/features/post/model/post/post.dart';
import 'package:madsm/routing/routes.dart';
import 'package:madsm/theme/app_colors.dart';
import 'package:madsm/utils/utils.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class NewFeedItem extends ConsumerStatefulWidget {
  const NewFeedItem({
    super.key,
    required this.post,
    this.isDetail = false,
  });

  final Post post;
  final bool isDetail;

  @override
  ConsumerState<NewFeedItem> createState() => _NewFeedItemState();
}

class _NewFeedItemState extends ConsumerState<NewFeedItem> {
  final controller = PageController();

  void _toggleLike() {
    ref.read(newFeedItemViewModelProvider(widget.post).notifier).toggleLike();
  }

  @override
  Widget build(BuildContext context) {
    final post = ref.watch(newFeedItemViewModelProvider(widget.post)).value?.post ?? widget.post;
    return Padding(
      padding: const EdgeInsets.only(bottom: Dimens.padding),
      child: InkWell(
        onTap: () {
          if (widget.isDetail) {
            return;
          }
          context.push(Routes.postDetail, extra: post);
        },
        onDoubleTap: _toggleLike,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: AppColors.lighterGrey.withValues(alpha: 0.4),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Dimens.padding,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 16,
                  children: [
                    _buildUserInfo(post),
                    if (post.content.isNotEmpty) _buildContent(post),
                    if (post.media.isNotEmpty) _buildMedia(post),
                    _buildActions(post),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfo(Post post) {
    return Row(
      children: [
        CircleAvatar(
          foregroundImage: NetworkImage(post.userAvatar),
        ),
        SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.post.userName,
              style: context.textTheme.bodyMedium?.w700,
            ),
            Text(
              Utils.calculateTimeDifference(widget.post.createdAt),
              style: context.textTheme.bodySmall?.lighterGrey,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContent(Post post) {
    return Text(
      post.content,
      style: context.textTheme.bodyLarge,
    );
  }

  Widget _buildMedia(Post post) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: constraints.maxWidth * 0.75,
          child: Column(
            spacing: 8,
            children: [
              Expanded(
                child: PageView(
                  controller: controller,
                  children: List.generate(
                    post.media.length,
                    (index) {
                      return GestureDetector(
                        onTap: () {
                          Utils.openPhotoView(
                            context: context,
                            imageProvider: NetworkImage(post.media[index].url),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(8),
                          child: Center(
                            child: CommonCachedImage(
                              imageUrl: post.media[index].url,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Visibility(
                visible: post.media.length > 1,
                child: SmoothPageIndicator(
                    controller: controller, // PageController
                    count: post.media.length,
                    effect: JumpingDotEffect(
                      dotWidth: 8,
                      dotHeight: 8,
                    ), // your preferred effect
                    onDotClicked: (index) {}),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildActions(Post post) {
    final isLiked = ref.watch(newFeedItemViewModelProvider(widget.post)).value?.isLiked ?? false;
    return Row(
      children: [
        Row(
          spacing: 8,
          children: [
            CommonLikeButton(
              isLiked: isLiked,
              onTap: _toggleLike,
            ),
            if (post.likeCount > 0) Text(post.likeCount.toString()),
          ],
        ),
        SizedBox(width: 20),
        Row(
          children: [
            InkWell(
              child: CommonSvgPicture(assetName: Assets.icComments),
            ),
            if (widget.post.commentCount > 0) Text(widget.post.commentCount.toString()),
          ],
        ),
        SizedBox(width: 20),
        InkWell(
          child: CommonSvgPicture(assetName: Assets.icShare),
        ),
      ],
    );
  }
}
