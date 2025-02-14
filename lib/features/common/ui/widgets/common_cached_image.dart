import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CommonCachedImage extends StatelessWidget {
  const CommonCachedImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.contain,
  });

  final String imageUrl;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      errorWidget: (context, url, error) => Icon(Icons.person),
      placeholder: (context, url) => CircularProgressIndicator(),
    );
  }
}
