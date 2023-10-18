import 'package:androidtvapp/application/model/video_model.dart';
import 'package:androidtvapp/values/constant_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class VideoWidget extends StatelessWidget {
  const VideoWidget({
    super.key,
    required this.video,
    this.onTap,
  });

  final Video video;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 200,
        width: 200,
        color: Colors.black.withOpacity(0.2),
        child: Stack(
          alignment: Alignment.center,
          children: [
            CachedNetworkImage(
              imageUrl: video.thumbnailUrl,
              fit: BoxFit.cover,
            ),
            Container(
              color: ConstantColors.black.withOpacity(0.4),
            ),
            const Icon(
              FontAwesomeIcons.circlePlay,
              color: ConstantColors.whiteColor,
            )
          ],
        ),
      ),
    );
  }
}
