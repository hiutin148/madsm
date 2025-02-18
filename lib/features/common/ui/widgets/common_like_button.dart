import 'package:flutter/material.dart';
import 'package:madsm/constants/assets.dart';
import 'package:madsm/features/common/ui/widgets/common_svg_picture.dart';

class CommonLikeButton extends StatefulWidget {
  const CommonLikeButton({
    super.key,
    required this.isLiked,
    required this.onTap,
  });

  final bool isLiked;
  final Function() onTap;

  @override
  State<CommonLikeButton> createState() => _CommonLikeButtonState();
}

class _CommonLikeButtonState extends State<CommonLikeButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleTransition(scale: animation, child: child);
        },
        child: widget.isLiked
            ? CommonSvgPicture(
                assetName: Assets.icLikeFilled,
                color: Theme.of(context).primaryColor,
                key: ValueKey<bool>(widget.isLiked),
              )
            : CommonSvgPicture(
                assetName: Assets.icLike,
                key: ValueKey<bool>(widget.isLiked),
              ),
      ),
    );
  }
}
