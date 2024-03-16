import 'package:androidtvapp/views/dashboard/dashboard_screen.dart';
import 'package:androidtvapp/views/video/full_video_screen.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import './route_constant.dart';

class Routers {
  static Route<dynamic> onGenerateRoute(RouteSettings routeSettings) {
    final args = routeSettings.arguments;

    switch (routeSettings.name) {
      case homeRoute:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());

      // Select Carousel Route
      case fullVideoRoute:
        return MaterialPageRoute(
          builder: (_) => FullVideoScreen(
            controller: args as YoutubePlayerController,
          ),
        );

      default:
        return MaterialPageRoute(builder: (_) => Container());
    }
  }
}
