import 'package:androidtvapp/views/donations.dart';
import 'package:androidtvapp/views/home/home_screen.dart';
import 'package:androidtvapp/views/live_stream/live_stream_screen.dart';
import 'package:androidtvapp/views/playlist/all_playlist_screen.dart';
import 'package:androidtvapp/views/playlist/playlist_detail_screen.dart';
import 'package:androidtvapp/views/video/video_detail_screen.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:dio/dio.dart';

class ScreenService extends ChangeNotifier {
  Widget? screen = const HomeScreen();

  YoutubePlayerController? videoController;
  YoutubePlayerController? playlistController;

  VideoPlayerController? liveStreamController;
  ChewieController? liveStreamChewieController;

  Dio dio = Dio();
  static const String apiUrl = "https://suborotv.net/api-app.php";

  // void screentoVideoDetail() async {
  //   screen = const ChannelVideos();

  //   notifyListeners();
  // }

  void screentoHomeScreen() {
    screen = const HomeScreen();
    notifyListeners();
  }

  void screentoVideoDetail() {
    screen = const VideoDetailScreen();
    notifyListeners();
  }

  // void screentoLiveStreamScreen() async {
  //   screen = const LiveStreamScreen();

  //   liveStreamController = VideoPlayerController.network(
  //     'http://fs4.suboroiptv.tv/suboromain/live/index.m3u8',
  //   );

  //   await liveStreamController!.initialize();

  //   liveStreamChewieController = ChewieController(
  //     videoPlayerController: liveStreamController!,
  //     autoPlay: true,
  //   );

  //   notifyListeners();
  // }

  void screentoLiveStreamScreen() async {
    screen = const LiveStreamScreen();

    try {
      // Make an API call to get the live stream URL
      Response response = await dio.get(apiUrl);

      if (response.statusCode == 200) {
        // Parse the response to get the live stream URL
        String liveStreamUrl = response.toString();
        print((response.toString()));

        liveStreamController = VideoPlayerController.network(
          liveStreamUrl,
        );

        await liveStreamController!.initialize();

        liveStreamChewieController = ChewieController(
          videoPlayerController: liveStreamController!,
          autoPlay: true,
        );
      } else {
        // Handle error if the API call fails
        print(
            "Failed to get live stream URL. Status code: ${response.statusCode}");
      }
    } catch (e) {
      // Handle any other exceptions that may occur during the process
      print("Error: $e");
      print("Error ABC : $e");
    }

    notifyListeners();
  }

  void screenToAllPlaylist() {
    screen = const AllPlaylistScreen();
    notifyListeners();
  }

  void screenToDonations(String url) {
    screen = DonationsScreen(url: url);
    notifyListeners();
  }

  void screentoPlaylistVideoDetail({
    required String videoId,
    required String playlistId,
  }) {
    screen = PlaylistDetailScreen(
      playlistId: playlistId,
      videoId: videoId,
    );

    notifyListeners();
  }

  String parseLiveStreamUrl(dynamic responseData) {
    // Implement your logic to extract the live stream URL from the API response
    // For example, you may use regular expressions or other parsing techniques
    // Here, I assume the response is a JSON object with a key 'liveStreamUrl'
    return responseData['liveStreamUrl'];
  }

  void setCurrentVideo({
    required BuildContext context,
    required String videoId,
  }) {
    videoController = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        controlsVisibleAtStart: false,
      ),
    );
    notifyListeners();
  }

  void setPlaylistVideo({
    required BuildContext context,
    required String videoId,
  }) {
    playlistController = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        controlsVisibleAtStart: false,
      ),
    );
    notifyListeners();
  }
}
