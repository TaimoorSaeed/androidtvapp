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

      channels = [];

      for (var element in (res.data["items"] as List)) {
        channels.add(Channel.fromMap(element));
      }

      isFetching = false;
      notifyListeners();

      return channels;
    } on DioException catch (e) {
      isFetching = false;
      notifyListeners();

      print(e.response!.data);

      return null;
    }
  }
}
