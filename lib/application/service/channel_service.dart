import 'dart:convert';
import 'package:androidtvapp/application/android_tv_api.dart';
import 'package:androidtvapp/application/model/channel_model.dart';
import 'package:androidtvapp/utils/keys.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ChannelService extends ChangeNotifier {
  final List<String> _channelIDs = [
    "UCPimsixs-5GZojVl2cDVDZA",
    "UCqhpiGbWAOKZuuB62UcDd3w",
    "UCRZN0FlAHD1TiCm20TUyK-w",
    "UCo_GrJqKEoqQhMWvkNvYWzQ",
    "UCcRtCpoZnUzyegvpQfdp2AQ",
    "UCm1mSD6ynKK7vQAHtFJEHeQ",
  ];

  List<Channel> channels = [];

  bool isFetching = false;

  Future<List<Channel>?> fetchChannels() async {
    try {
      isFetching = true;

      Map<String, dynamic> parameters = {
        'part': 'snippet, contentDetails, statistics',
        'key': YOUTUBE_API_KEY,
        'id': _channelIDs,
      };

      var res = await AndroidTVApi.dio.get(
        "channels",
        queryParameters: parameters,
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
        ),
      );

      for (var element in (res.data["items"] as List)) {
        channels.add(Channel.fromMap(element));
      }

      isFetching = false;
      notifyListeners();

      return channels;
    } on DioException catch (e) {
      isFetching = true;
      notifyListeners();

      print(e.response!.data);

      throw json.decode(e.response!.data)["error"]["message"];
    }
  }

  // Future<List<Video>> fetchVideosFromPlaylist({String playlistId}) async {
  //   Map<String, String> parameters = {
  //     'part': 'snippet',
  //     'playlistId': playlistId,
  //     'maxResults': '8',
  //     'pageToken': _nextPageToken,
  //     'key': API_KEY,
  //   };
  //   Uri uri = Uri.https(
  //     _baseUrl,
  //     '/youtube/v3/playlistItems',
  //     parameters,
  //   );
  //   Map<String, String> headers = {
  //     HttpHeaders.contentTypeHeader: 'application/json',
  //   };

  //   // Get Playlist Videos
  //   var response = await http.get(uri, headers: headers);
  //   if (response.statusCode == 200) {
  //     var data = json.decode(response.body);

  //     _nextPageToken = data['nextPageToken'] ?? '';
  //     List<dynamic> videosJson = data['items'];

  //     // Fetch first eight videos from uploads playlist
  //     List<Video> videos = [];
  //     videosJson.forEach(
  //       (json) => videos.add(
  //         Video.fromMap(json['snippet']),
  //       ),
  //     );
  //     return videos;
  //   } else {
  //     throw json.decode(response.body)['error']['message'];
  //   }
  // }
}
