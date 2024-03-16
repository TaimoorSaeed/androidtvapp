import 'package:androidtvapp/application/model/playlist_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PlaylistWidget extends StatelessWidget {
  const PlaylistWidget({
    super.key,
    required this.playlist,
    this.onTap,
  });

  final Playlist playlist;
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
                  imageUrl: playlist.thumbnailUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 100,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            playlist.title,
            style: const TextStyle(
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            "View Playlist",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }
}
