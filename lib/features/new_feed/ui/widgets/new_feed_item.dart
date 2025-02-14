import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:madsm/constants/assets.dart';
import 'package:madsm/features/common/ui/widgets/common_cached_image.dart';
import 'package:madsm/features/common/ui/widgets/common_svg_picture.dart';
import 'package:madsm/features/new_feed/ui/view_model/new_feed_item_view_model.dart';
import 'package:madsm/features/post/model/post.dart';
import 'package:madsm/theme/app_colors.dart';
import 'package:madsm/utils/utils.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class NewFeedItem extends ConsumerStatefulWidget {
  const NewFeedItem({super.key, required this.post});

  final Post post;

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
    return GestureDetector(
      onDoubleTap: _toggleLike,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserInfo(post),
            if (post.content.isNotEmpty) _buildContent(post),
            if (post.media.isNotEmpty) _buildMedia(post),
            _buildActions(post),
            Divider(color: AppColors.darkGrey),
          ],
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
          children: [
            Text(widget.post.userName),
            Text(Utils.calculateTimeDifference(widget.post.createdAt)),
          ],
        ),
      ],
    );
  }

  Widget _buildContent(Post post) {
    return Text(post.content);
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
                          color: Colors.black,
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
            InkWell(
              onTap: _toggleLike,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(scale: animation, child: child);
                },
                child: isLiked
                    ? CommonSvgPicture(
                        assetName: Assets.icLikeFilled,
                        color: Theme.of(context).primaryColor,
                        key: ValueKey<bool>(isLiked),
                      )
                    : CommonSvgPicture(
                        assetName: Assets.icLike,
                        key: ValueKey<bool>(isLiked),
                      ),
              ),
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
