import 'package:androidtvapp/application/model/playlist_model.dart';
import 'package:androidtvapp/application/service/playlist_service.dart';
import 'package:androidtvapp/application/service/screen_service.dart';
import 'package:androidtvapp/application/service/video_service.dart';
import 'package:androidtvapp/router/route_constant.dart';
import 'package:androidtvapp/values/constant_colors.dart';
import 'package:androidtvapp/widgets/playlist_item_widget.dart';
import 'package:androidtvapp/widgets/playlist_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PlaylistDetailScreen extends StatefulWidget {
  const PlaylistDetailScreen({
    super.key,
    required this.playlistId,
    required this.videoId,
  });

  final String playlistId;
  final String videoId;

  @override
  State<PlaylistDetailScreen> createState() => _PlaylistDetailScreenState();
}

class _PlaylistDetailScreenState extends State<PlaylistDetailScreen> {
  void _onKeyPressed(RawKeyEvent e) {
    print("Event: $e");

    var screenService = Provider.of<ScreenService>(context, listen: false);

    if (e.logicalKey == LogicalKeyboardKey.select) {
      Navigator.pushNamed(
        context,
        fullVideoRoute,
        arguments: screenService.playlistController!,
      );
    } else if (e.logicalKey == LogicalKeyboardKey.mediaPlayPause) {
      setState(() {
        if (screenService.playlistController!.value.isPlaying) {
          screenService.playlistController!.pause();
        } else {
          screenService.playlistController!.play();
        }
      });
    } else if (e.logicalKey == LogicalKeyboardKey.arrowUp) {
      // Handle arrow up key press
    } else if (e.logicalKey == LogicalKeyboardKey.arrowDown) {
      // Handle arrow down key press
    } else if (e.logicalKey == LogicalKeyboardKey.arrowLeft) {
      // Handle arrow left key press
    } else if (e.logicalKey == LogicalKeyboardKey.arrowRight) {
      // Handle arrow right key press
    } else if (e.logicalKey == LogicalKeyboardKey.enter) {
      // Handle enter key press
    } else if (e.logicalKey == LogicalKeyboardKey.escape) {
      // Handle escape key press (exit full-screen, for example)
    }
  }

  @override
  void deactivate() {
    var screenService = Provider.of<ScreenService>(context, listen: false);
    screenService.playlistController!.dispose();
    print("Here i am in player details");
    super.deactivate();
  }

  @override
  void initState() {
    print("CCC");
    _getData();
    super.initState();
  }

  _getData() {
    print("AAAA");
    print(widget.videoId);
    print(widget.playlistId);

    Provider.of<PlaylistService>(context, listen: false)
        .fetchPlaylistItems(
      playlistId: widget.playlistId,
    )
        .then((value) {
      if (value.isNotEmpty) {
        Provider.of<ScreenService>(context, listen: false).setPlaylistVideo(
          context: context,
          videoId: value[0].videoId,
        );

        Provider.of<VideoService>(context, listen: false).fetchVideo(
          videoID: value[0].videoId,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenService = Provider.of<ScreenService>(context);
    var videoService = Provider.of<VideoService>(context);
    var playlistService = Provider.of<PlaylistService>(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 650) {
          return RawKeyboardListener(
            focusNode: FocusNode(),
            onKey: _onKeyPressed,
            child: Scaffold(
              backgroundColor: ConstantColors.mainColor,
              body: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [
                      0.1,
                      0.7,
                    ],
                    colors: [
                      ConstantColors.secondMainColor,
                      ConstantColors.mainColor,
                    ],
                  ),
                ),
                child: videoService.isVideoFetching ||
                        screenService.playlistController == null ||
                        playlistService.isLoading ||
                        videoService.isSuggestionVideosFetching
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: ConstantColors.whiteColor,
                        ),
                      )
                    : SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 60,
                            right: 60,
                            bottom: 20,
                            top: 30,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Suboro TV",
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                    const SizedBox(height: 25),
                                    YoutubePlayer(
                                      controller:
                                          screenService.playlistController!,
                                      showVideoProgressIndicator: true,
                                      width:
                                          MediaQuery.of(context).size.width / 2,
                                      aspectRatio: 16 / 9,
                                      bottomActions: [
                                        CurrentPosition(
                                          controller:
                                              screenService.playlistController!,
                                        ),
                                        ProgressBar(
                                          isExpanded: true,
                                          controller:
                                              screenService.playlistController!,
                                          colors: const ProgressBarColors(
                                            playedColor: Colors.white,
                                            handleColor: Colors.white,
                                          ),
                                        ),
                                        RemainingDuration(
                                          controller:
                                              screenService.playlistController!,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.pushNamed(
                                              context,
                                              fullVideoRoute,
                                              arguments: screenService
                                                  .playlistController!,
                                            );
                                          },
                                          child: const Icon(
                                            Icons.fullscreen,
                                          ),
                                        )
                                        // TotalDuration(),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    Text(videoService.singleVideo!.title),
                                    const SizedBox(height: 15),
                                    Text(
                                      "${videoService.singleVideo!.views} views",
                                      style: const TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    InkWell(
                                      onTap: () {},
                                      child: Text(
                                        videoService.singleVideo!.description,
                                        style: const TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 2.8,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GridView.count(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 10.0,
                                      mainAxisSpacing: 10.0,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      children: List.generate(
                                        playlistService.playlistItems.length,
                                        (index) {
                                          var playlistItem = playlistService
                                              .playlistItems[index];

                                          return PlaylistItemWidget(
                                            playlistItem: playlistItem,
                                            onTap: () {
                                              screenService
                                                  .screentoPlaylistVideoDetail(
                                                videoId: playlistItem.videoId,
                                                playlistId:
                                                    playlistItem.playlistId,
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
            ),
          );
        } else {
          return Scaffold(
            backgroundColor: ConstantColors.mainColor,
            body: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [
                    0.1,
                    0.7,
                  ],
                  colors: [
                    ConstantColors.secondMainColor,
                    ConstantColors.mainColor,
                  ],
                ),
              ),
              child: videoService.isVideoFetching ||
                      screenService.playlistController == null ||
                      // screenService.currentChannelID == null ||
                      videoService.isSuggestionVideosFetching
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: ConstantColors.whiteColor,
                      ),
                    )
                  : SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Suboro TV",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(height: 25),
                            YoutubePlayer(
                              controller: screenService.playlistController!,
                              showVideoProgressIndicator: true,
                              width: MediaQuery.of(context).size.width,
                              aspectRatio: 16 / 9,
                              bottomActions: [
                                CurrentPosition(
                                  controller: screenService.playlistController!,
                                ),
                                ProgressBar(
                                  isExpanded: true,
                                  controller: screenService.playlistController!,
                                  colors: const ProgressBarColors(
                                    playedColor: Colors.white,
                                    handleColor: Colors.white,
                                  ),
                                ),
                                RemainingDuration(
                                  controller: screenService.playlistController!,
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      fullVideoRoute,
                                      arguments:
                                          screenService.playlistController!,
                                    );
                                  },
                                  child: const Icon(
                                    Icons.fullscreen,
                                  ),
                                )
                                // TotalDuration(),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Text(videoService.singleVideo!.title),
                            const SizedBox(height: 15),
                            Text(
                              "${videoService.singleVideo!.views} views",
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              videoService.singleVideo!.description,
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 20),
                            GridView.count(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10.0,
                              mainAxisSpacing: 10.0,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              children: List.generate(
                                playlistService.playlistItems.length,
                                (index) {
                                  var playlistItem =
                                      playlistService.playlistItems[index];

                                  return PlaylistItemWidget(
                                    playlistItem: playlistItem,
                                    onTap: () {
                                      print("Hello i am here 3");
                                      print(playlistItem.playlistId);
                                      print(playlistItem.videoId);

                                      Provider.of<PlaylistService>(context,
                                              listen: false)
                                          .fetchPlaylistItems(
                                        playlistId: widget.playlistId,
                                      )
                                          .then((value) {
                                        if (value.isNotEmpty) {
                                          Provider.of<ScreenService>(context,
                                                  listen: false)
                                              .setPlaylistVideo(
                                            context: context,
                                            videoId: playlistItem.videoId,
                                          );

                                          Provider.of<VideoService>(context,
                                                  listen: false)
                                              .fetchVideo(
                                            videoID: playlistItem.videoId,
                                          );
                                        }
                                      });

                                      // screenService.screentoPlaylistVideoDetail(
                                      //   videoId: playlistItem.videoId,
                                      // );

                                      // screenService
                                      //     .setscreentoPlaylistVideoDetail(
                                      //         context: context,
                                      //         videoId: playlistItem.videoId,
                                      //         playlistId:
                                      //             playlistItem.playlistId);

                                      // screenService.setCurrentVideo(
                                      //     context: context,
                                      //     videoId: playlistItem.videoId);

                                      // videoService.fetchVideo(
                                      //     videoID: playlistItem.videoId);

                                      // screenService.screentoVideoDetail()

                                      // screenService.screentoPlaylistVideoDetail(
                                      //     videoId: playlistItem.videoId,
                                      //     playlistId: playlistItem.playlistId);
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          );
        }
      },
    );
  }
}
