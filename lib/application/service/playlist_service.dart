import 'package:androidtvapp/application/android_tv_api.dart';
import 'package:androidtvapp/application/model/playlist_item_model.dart';
import 'package:androidtvapp/application/model/playlist_model.dart';
import 'package:androidtvapp/utils/keys.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class PlaylistService extends ChangeNotifier {
  bool isLoading = false;
  bool isFetching = false;

  List<Playlist> playlists = [];
  List<Playlist> allPlaylists = [];

  List<PlaylistItem> playlistItems = [];

  String? nextPageToken = "";

  Future fetchAllPlaylists() async {
    try {
      isLoading = true;

      Map<String, dynamic> parameters = {};

      var res = await AndroidTVApi.dio.get(
        "latestplaylists.php",
        queryParameters: parameters,
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
        ),
      );

      playlists = [];

      for (var element in (res.data["items"] as List)) {
        playlists.add(Playlist.fromMap(element));
      }

      isLoading = false;
      notifyListeners();

      return playlists;
    } on DioException catch (e) {
      isLoading = false;
      notifyListeners();

      print(e.response!.data);
      return null;
    }
  }

  Future fetchChannelAllPlaylists() async {
    try {
      isLoading = true;

      Map<String, dynamic> parameters = {};

      var res = await AndroidTVApi.dio.get(
        "allplaylists.php",
        queryParameters: parameters,
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
        ),
      );

      allPlaylists = [];
      nextPageToken = res.data["nextPageToken"];

      for (var element in (res.data["items"] as List)) {
        allPlaylists.add(Playlist.fromMap(element));
      }

      isLoading = false;
      notifyListeners();

      return allPlaylists;
    } on DioException catch (e) {
      isLoading = false;
      notifyListeners();

      print(e.response!.data);
      return null;
    }
  }

  Future fetchChannelAllPlaylistsWithPagination() async {
    try {
      isFetching = true;

      Map<String, dynamic> parameters = {
        'pageToken': nextPageToken,
      };

      var res = await AndroidTVApi.dio.get(
        "allplaylists_paginated.php",
        queryParameters: parameters,
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
        ),
      );

      nextPageToken = res.data["nextPageToken"];

      for (var element in (res.data["items"] as List)) {
        allPlaylists.add(Playlist.fromMap(element));
      }

      isFetching = false;
      notifyListeners();

      return allPlaylists;
    } on DioException catch (e) {
      isFetching = false;
      notifyListeners();

      print(e.response!.data);
      return null;
    }
  }

  Future<List<PlaylistItem>> fetchPlaylistItems({
    required String playlistId,
  }) async {
    try {
      isLoading = true;

      Map<String, dynamic> parameters = {
        'playlistId': playlistId,
      };

      var res = await AndroidTVApi.dio.get(
        "getplaylistitems.php",
        queryParameters: parameters,
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
        ),
      );

      playlistItems = [];

      for (var element in (res.data["items"] as List)) {
        playlistItems.add(PlaylistItem.fromMap(element));
      }

      isLoading = false;
      notifyListeners();

      return playlistItems;
    } on DioException catch (e) {
      isLoading = false;
      notifyListeners();

      print(e.response!.data);

      return playlistItems;
    }
  }
}
