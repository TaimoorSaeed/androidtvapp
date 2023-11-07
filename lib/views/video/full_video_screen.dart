import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class FullVideoScreen extends StatefulWidget {
  const FullVideoScreen({
    super.key,
    required this.controller,
  });

  final YoutubePlayerController controller;

  @override
  State<FullVideoScreen> createState() => _FullVideoScreenState();
}

class _FullVideoScreenState extends State<FullVideoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: YoutubePlayer(
        controller: widget.controller,
        showVideoProgressIndicator: true,
        width: MediaQuery.of(context).size.width,
        // aspectRatio: 16 / 9,
        bottomActions: [
          CurrentPosition(
            controller: widget.controller,
          ),
          ProgressBar(
            isExpanded: true,
            controller: widget.controller,
            colors: const ProgressBarColors(
              playedColor: Colors.white,
              handleColor: Colors.white,
            ),
          ),
          RemainingDuration(
            controller: widget.controller,
          ),
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.fullscreen_exit,
            ),
          )
        ],
      ),
    );
  }
}
