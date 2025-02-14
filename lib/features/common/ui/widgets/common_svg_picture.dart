import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CommonSvgPicture extends StatelessWidget {
  const CommonSvgPicture({
    super.key,
    required this.assetName,
    this.color, this.size = 20,
  });

  final String assetName;
  final Color? color;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      assetName,
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(
        color ?? (Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white),
        BlendMode.srcIn,
      ),
    );
  }
}
