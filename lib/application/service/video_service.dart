import 'package:androidtvapp/application/android_tv_api.dart';
import 'package:androidtvapp/application/model/single_video_model.dart';
import 'package:androidtvapp/application/model/video_model.dart';
import 'package:androidtvapp/utils/keys.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class VideoService extends ChangeNotifier {
  List<Video> broadcastingVideos = [];
  List<Video> latestVideos = [];
  List<Video> popularVideos = [];
  List<Video> suggestionVideos = [];

  SingleVideo? singleVideo;

  bool isBroadcastVideosFetching = false;
  bool isLatestVideosFetching = false;
  bool isPopularVideosFetching = false;
  bool isVideoFetching = false;
  bool isSuggestionVideosFetching = false;

  Future<List<Video>?> fetchBroadcastingVideos({
    required String channelID,
  }) async {
    try {
      isBroadcastVideosFetching = true;

      Map<String, dynamic> parameters = {
        'part': 'snippet',
        'key': YOUTUBE_API_KEY,
        'channelId': channelID,
        'eventType': 'completed',
        'order': 'date',
        'maxResults': 10,
        'type': 'video'
      };

      var res = await AndroidTVApi.dio.get(
        "search",
        queryParameters: parameters,
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
        ),
      );

      broadcastingVideos = [];

      for (var element in (res.data["items"] as List)) {
        broadcastingVideos.add(Video.fromMap(element));
      }

      isBroadcastVideosFetching = false;
      notifyListeners();

      return broadcastingVideos;
    } on DioException catch (e) {
      isBroadcastVideosFetching = false;
      notifyListeners();

      print(e.response!.data);

      return null;
    }
  }

  Future<List<Video>?> fetchLatestVideos({
    required String channelID,
  }) async {
    try {
      isLatestVideosFetching = true;

      Map<String, dynamic> parameters = {
        'part': 'snippet',
        'key': YOUTUBE_API_KEY,
        'channelId': channelID,
        'order': 'date',
        'maxResults': 10,
        'type': 'video'
      };

      var res = await AndroidTVApi.dio.get(
        "search",
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

  Future<List<Video>?> fetchPopularVideos({
    required String channelID,
  }) async {
    try {
      isPopularVideosFetching = true;

      Map<String, dynamic> parameters = {
        'part': 'snippet',
        'key': YOUTUBE_API_KEY,
        'channelId': channelID,
        'order': 'viewCount',
        'maxResults': 10,
        'type': 'video'
      };

      var res = await AndroidTVApi.dio.get(
        "search",
        queryParameters: parameters,
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
        ),
      );

      popularVideos = [];

      for (var element in (res.data["items"] as List)) {
        popularVideos.add(Video.fromMap(element));
      }

      isPopularVideosFetching = false;
      notifyListeners();

      return popularVideos;
    } on DioException catch (e) {
      isPopularVideosFetching = false;
      notifyListeners();

      print(e.response!.data);

      return null;
    }
  }

  Future<List<Video>?> fetchSuggestionVideos({
    required String channelID,
  }) async {
    try {
      isSuggestionVideosFetching = true;

      Map<String, dynamic> parameters = {
        'part': 'snippet',
        'key': YOUTUBE_API_KEY,
        'channelId': channelID,
        'maxResults': 4,
        'order': 'relevance',
        'type': 'video'
      };

      var res = await AndroidTVApi.dio.get(
        "search",
        queryParameters: parameters,
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
        ),
      );

      suggestionVideos = [];

      print(res.data["items"]);

      for (var element in (res.data["items"] as List)) {
        suggestionVideos.add(Video.fromMap(element));
      }

      isSuggestionVideosFetching = false;
      notifyListeners();

      return suggestionVideos;
    } on DioException catch (e) {
      isSuggestionVideosFetching = false;
      notifyListeners();

      print(e.response!.data);

      return null;
    }
  }

  Future<List<Video>?> fetchVideo({
    required String videoID,
  }) async {
    try {
      isVideoFetching = true;
      notifyListeners();

      Map<String, dynamic> parameters = {
        'part': 'snippet,contentDetails,statistics',
        'key': YOUTUBE_API_KEY,
        'id': videoID,
      };

      var res = await AndroidTVApi.dio.get(
        "videos",
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

      return popularVideos;
    } on DioException catch (e) {
      isVideoFetching = false;
      notifyListeners();

      print(e.response!.data);

      return null;
    }
  }
}
