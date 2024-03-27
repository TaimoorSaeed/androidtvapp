// ignore_for_file: avoid_print

import 'package:androidtvapp/application/android_tv_api.dart';
import 'package:androidtvapp/application/model/single_video_model.dart';
import 'package:androidtvapp/application/model/video_model.dart';
import 'package:androidtvapp/utils/keys.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class VideoService extends ChangeNotifier {
  List<Video> latestVideos = [];

  SingleVideo? singleVideo;

  bool isBroadcastVideosFetching = false;
  bool isLatestVideosFetching = false;
  bool isPopularVideosFetching = false;
  bool isVideoFetching = false;
  bool isSuggestionVideosFetching = false;

  Future<List<Video>?> fetchLatestVideos() async {
    try {
      isLatestVideosFetching = true;

      Map<String, dynamic> parameters = {};

      var res = await AndroidTVApi.dio.get(
        "latestvideos.php",
        queryParameters: parameters,
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
        ),
      );

      latestVideos = [];

      for (var element in (res.data["items"] as List)) {
        latestVideos.add(Video.fromMap(element));
      }

      isLatestVideosFetching = false;
      notifyListeners();

      return latestVideos;
    } on DioException catch (e) {
      isLatestVideosFetching = false;
      notifyListeners();

      print(e.response!.data);

      return null;
    }
  }

  Future<SingleVideo?> fetchVideo({
    required String videoID,
  }) async {
    try {
      isVideoFetching = true;
      notifyListeners();

      Map<String, dynamic> parameters = {
        'id': videoID,
      };

      var res = await AndroidTVApi.dio.get(
        "getvideo.php",
        queryParameters: parameters,
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
        ),
      );

      singleVideo = SingleVideo.fromMap(res.data["items"][0]);

      isVideoFetching = false;
      notifyListeners();

      return singleVideo;
    } on DioException catch (e) {
      isVideoFetching = false;
      notifyListeners();

      print(e.response!.data);

      return null;
    }
  }
}
