import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:madsm/constants/assets.dart';
import 'package:madsm/features/common/ui/widgets/common_cached_image.dart';
import 'package:madsm/features/post/model/post.dart';
import 'package:madsm/theme/app_colors.dart';

class NewFeedItem extends StatefulWidget {
  const NewFeedItem({super.key, required this.post});

  final Post post;

  @override
  State<NewFeedItem> createState() => _NewFeedItemState();
}

class _NewFeedItemState extends State<NewFeedItem> {
  bool isLiked = false;

  void _toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUserInfo(),
          SizedBox(height: 16),
          if (widget.post.content.isNotEmpty) _buildContent(),
          if (widget.post.media.isNotEmpty) _buildMedia(),
          SizedBox(height: 16),
          _buildActions(),
          Divider(color: AppColors.darkGrey),
        ],
      ),
    );
  }

  Widget _buildUserInfo() {
    return Row(
      children: [
        CircleAvatar(),
        SizedBox(width: 8),
        Text("USER Name"),
      ],
    );
  }

  Widget _buildContent() {
    return Text(widget.post.content);
  }

  Widget _buildMedia() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: constraints.maxWidth * 0.75,
          child: PageView(
            children: List.generate(
              widget.post.media.length,
              (index) {
                return CommonCachedImage(
                  imageUrl: widget.post.media[index].url,
                  fit: BoxFit.contain,
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildActions() {
    return Row(
      children: [
        Row(
          children: [
            InkWell(
              onTap: _toggleLike,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(scale: animation, child: child);
                },
                child: isLiked
                    ? SvgPicture.asset(
                        Assets.icCamera,
                        key: ValueKey<bool>(isLiked),
                      )
                    : SvgPicture.asset(
                        Assets.icLike,
                        key: ValueKey<bool>(isLiked),
                      ),
              ),
            ),
            if (widget.post.likeCount > 0) Text(widget.post.likeCount.toString()),
          ],
        ),
        SizedBox(width: 20),
        Row(
          children: [
            InkWell(
              child: SvgPicture.asset(Assets.icComments),
            ),
            if (widget.post.commentCount > 0) Text(widget.post.commentCount.toString()),
          ],
        ),
        SizedBox(width: 20),
        InkWell(
          child: SvgPicture.asset(Assets.icShare),
        ),
      ],
    );
  }
}
