import 'package:androidtvapp/application/model/playlist_item_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PlaylistItemWidget extends StatelessWidget {
  const PlaylistItemWidget({
    super.key,
    required this.playlistItem,
    required this.onTap,
  });

  final PlaylistItem playlistItem;
  final void Function() onTap;

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
                borderRadius: BorderRadius.circular(
                  10,
                ),
                child: CachedNetworkImage(
                  imageUrl: playlistItem.thumbnailUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 100,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            playlistItem.title,
            style: const TextStyle(
              fontSize: 11,
            ),
          )
        ],
      ),
    );
  }
}
