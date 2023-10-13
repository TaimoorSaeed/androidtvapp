import 'package:androidtvapp/views/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import './route_constant.dart';

class Routers {
  static Route<dynamic> onGenerateRoute(RouteSettings routeSettings) {
    final args = routeSettings.arguments;

    switch (routeSettings.name) {
      case homeRoute:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      // Select Carousel Route
      // case carouselRoute:
      //   return PageTransition(
      //     child: CarouselScreen(
      //       images: args as List<ImageModel>,
      //     ),
      //     type: PageTransitionType.rightToLeft,
      //   );

      default:
        return MaterialPageRoute(builder: (_) => Container());
    }
  }
}
