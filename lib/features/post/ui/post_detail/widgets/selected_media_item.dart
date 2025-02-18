import 'package:flutter/material.dart';
import 'package:madsm/features/post/model/post/post.dart';
import 'package:madsm/theme/app_colors.dart';

class SelectedMediaItem extends StatelessWidget {
  const SelectedMediaItem({super.key, required this.media, required this.onTap, required this.onDelete});

  final Media media;
  final Function() onTap;
  final Function() onDelete;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: AppColors.lighterGrey),
        ),
        child: Stack(
          children: [
            buildDisplay(),
            Positioned(
              top: 0,
              right: 0,
              child: InkWell(
                onTap: onDelete,
                child: Icon(
                  Icons.close,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildDisplay() {
    switch (media.type) {
      case MediaType.image:
        return buildImageDisplay();
      case MediaType.gif:
        return buildGIFDisplay();
      case MediaType.file:
        return buildImageDisplay();
      case MediaType.video:
        return buildImageDisplay();
    }
  }

  Widget buildImageDisplay() {
    return Image.network(
      media.url,
    );
  }

  Widget buildGIFDisplay() {
    return SizedBox(
      child: Image.network(
        media.url,
        headers: {'accept': 'image/*'},
      ),
    );
  }
}
