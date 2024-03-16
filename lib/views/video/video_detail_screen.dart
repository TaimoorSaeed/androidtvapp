import 'package:androidtvapp/application/service/screen_service.dart';
import 'package:androidtvapp/application/service/video_service.dart';
import 'package:androidtvapp/router/route_constant.dart';
import 'package:androidtvapp/values/constant_colors.dart';
import 'package:androidtvapp/widgets/video_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoDetailScreen extends StatefulWidget {
  const VideoDetailScreen({
    super.key,
  });

  @override
  State<VideoDetailScreen> createState() => _VideoDetailScreenState();
}

class _VideoDetailScreenState extends State<VideoDetailScreen> {
  void _onKeyPressed(RawKeyEvent e) {
    print("Event: $e");

    var screenService = Provider.of<ScreenService>(context, listen: false);

    if (e.logicalKey == LogicalKeyboardKey.select) {
      Navigator.pushNamed(
        context,
        fullVideoRoute,
        arguments: screenService.videoController!,
      );
    } else if (e.logicalKey == LogicalKeyboardKey.mediaPlayPause) {
      setState(() {
        if (screenService.videoController!.value.isPlaying) {
          screenService.videoController!.pause();
        } else {
          screenService.videoController!.play();
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
    screenService.videoController!.dispose();
    print("AAAKKK");
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    var screenService = Provider.of<ScreenService>(context, listen: true);
    var videoService = Provider.of<VideoService>(context, listen: true);

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
                        screenService.videoController == null ||
                        // screenService.currentChannelID == null ||
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
                                          screenService.videoController!,
                                      showVideoProgressIndicator: true,
                                      width:
                                          MediaQuery.of(context).size.width / 2,
                                      aspectRatio: 16 / 9,
                                      bottomActions: [
                                        CurrentPosition(
                                          controller:
                                              screenService.videoController!,
                                        ),
                                        ProgressBar(
                                          isExpanded: true,
                                          controller:
                                              screenService.videoController!,
                                          colors: const ProgressBarColors(
                                            playedColor: Colors.white,
                                            handleColor: Colors.white,
                                          ),
                                        ),
                                        RemainingDuration(
                                          controller:
                                              screenService.videoController!,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.pushNamed(
                                              context,
                                              fullVideoRoute,
                                              arguments: screenService
                                                  .videoController!,
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
                                        videoService.latestVideos.length,
                                        (index) {
                                          var video =
                                              videoService.latestVideos[index];

                                          return VideoWidget(
                                            video: video,
                                            onTap: () {
                                              screenService.setCurrentVideo(
                                                context: context,
                                                videoId: video.id,
                                              );
                                              videoService.fetchVideo(
                                                  videoID: video.id);
                                              screenService
                                                  .screentoVideoDetail();
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
                      screenService.videoController == null ||
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
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              "Suboro TV",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(height: 25),
                            YoutubePlayer(
                              controller: screenService.videoController!,
                              showVideoProgressIndicator: true,
                              width: MediaQuery.of(context).size.width,
                              aspectRatio: 16 / 9,
                              bottomActions: [
                                CurrentPosition(
                                  controller: screenService.videoController!,
                                ),
                                ProgressBar(
                                  isExpanded: true,
                                  controller: screenService.videoController!,
                                  colors: const ProgressBarColors(
                                    playedColor: Colors.white,
                                    handleColor: Colors.white,
                                  ),
                                ),
                                RemainingDuration(
                                  controller: screenService.videoController!,
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      fullVideoRoute,
                                      arguments: screenService.videoController!,
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
                                videoService.latestVideos.length,
                                (index) {
                                  var video = videoService.latestVideos[index];

                                  return VideoWidget(
                                    video: video,
                                    onTap: () {
                                      screenService.setCurrentVideo(
                                        context: context,
                                        videoId: video.id,
                                      );
                                      videoService.fetchVideo(
                                          videoID: video.id);

                                      screenService.screentoVideoDetail();
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
