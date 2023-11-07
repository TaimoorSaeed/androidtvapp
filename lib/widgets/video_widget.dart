import 'package:androidtvapp/application/model/video_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: video.thumbnailUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 100,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            video.title,
            style: const TextStyle(
              fontSize: 11,
            ),
          )
        ],
      ),
    );
  }
}
