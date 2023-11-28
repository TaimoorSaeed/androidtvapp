import 'package:androidtvapp/application/model/video_model.dart';
import 'package:androidtvapp/application/service/video_service.dart';
import 'package:androidtvapp/views/channel/channel_videos.dart';
import 'package:androidtvapp/views/dashboard/dashboard_screen.dart';
import 'package:androidtvapp/views/video/video_detail_screen.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ScreenService extends ChangeNotifier {
  Widget? screen = const DashboardScreen();

  String? currentChannelID;
  String? currentChannelName;

  YoutubePlayerController? controller;

  late VideoPlayerController liveStreamController;
  ChewieController? chewieController;

  void screentoChannelVideo({
    required String channelID,
    required String channelName,
  }) async {
    currentChannelID = channelID;
    currentChannelName = channelName;
    screen = const ChannelVideos();

    if (channelName != "Suboro TV") {
      if (liveStreamController.hasListeners) {
        liveStreamController.dispose();
        chewieController!.dispose();
      }
    } else {
      liveStreamController = VideoPlayerController.network(
        'http://fs4.suboroiptv.tv/suboromain/live/index.m3u8',
      );

      await liveStreamController.initialize();

      chewieController = ChewieController(
        videoPlayerController: liveStreamController,
        autoPlay: true,
      );
    }

    notifyListeners();
  }

  void screentoDashboardScreen() {
    screen = const DashboardScreen();

    notifyListeners();
  }

  void screentoVideoDetail() {
    screen = const VideoDetailScreen();
    notifyListeners();
  }

  void setCurrentVideo({
    required BuildContext context,
    required Video video,
  }) {
    Provider.of<VideoService>(context, listen: false)
        .fetchSuggestionVideos(channelID: currentChannelID!);

    controller = YoutubePlayerController(
      initialVideoId: video.id,
      flags: const YoutubePlayerFlags(
        controlsVisibleAtStart: false,
      ),
    );
    notifyListeners();
  }
}
