import 'package:androidtvapp/application/model/video_model.dart';
import 'package:androidtvapp/application/service/video_service.dart';
import 'package:androidtvapp/views/channel/channel_videos.dart';
import 'package:androidtvapp/views/dashboard/dashboard_screen.dart';
import 'package:androidtvapp/views/video/video_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ScreenService extends ChangeNotifier {
  Widget? screen = const DashboardScreen();

  String? currentChannelID;
  String? currentChannelName;

  YoutubePlayerController? controller;

  void screentoChannelVideo({
    required String channelID,
    required String channelName,
  }) {
    currentChannelID = channelID;
    currentChannelName = channelName;
    screen = const ChannelVideos();

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
        controlsVisibleAtStart: true,
      ),
    );
    notifyListeners();
  }
}
