import 'package:androidtvapp/views/channel/channel_videos.dart';
import 'package:androidtvapp/views/video/video_detail_screen.dart';
import 'package:flutter/material.dart';

class ScreenService extends ChangeNotifier {
  Widget? screen = const ChannelVideos();

  void screentoChannelVideo() {
    screen = const ChannelVideos();
    notifyListeners();
  }

  void screentoVideoDetail() {
    screen = const VideoDetailScreen();
    notifyListeners();
  }
}
