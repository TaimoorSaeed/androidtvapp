import 'dart:io';
import 'package:androidtvapp/application/service/screen_service.dart';
import 'package:androidtvapp/application/service/video_service.dart';
import 'package:androidtvapp/router/route_constant.dart';
import 'package:androidtvapp/values/constant_colors.dart';
import 'package:androidtvapp/widgets/video_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
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
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  final adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-3940256099942544/2934735716';

  void loadAd() {
    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          debugPrint('$ad loaded.');
          setState(() {
            _isLoaded = true;
          });
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {
          debugPrint('BannerAd failed to load: $err');
          // Dispose the ad here to free resources.
          ad.dispose();
        },
      ),
    )..load();
  }

  void _onKeyPressed(RawKeyEvent event) {
    var screenService = Provider.of<ScreenService>(context, listen: true);

    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.pause) {
        screenService.controller!.pause();
      } else if (event.logicalKey == LogicalKeyboardKey.play) {
        screenService.controller!.play();
      }
    }
  }

  @override
  void initState() {
    loadAd();
    super.initState();
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
              body: videoService.isVideoFetching ||
                      screenService.controller == null ||
                      screenService.currentChannelID == null ||
                      videoService.isSuggestionVideosFetching
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: ConstantColors.whiteColor,
                      ),
                    )
                  : SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 60, right: 60, bottom: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    screenService.currentChannelName!,
                                    style: const TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                  const SizedBox(height: 25),
                                  YoutubePlayer(
                                    controller: screenService.controller!,
                                    showVideoProgressIndicator: true,
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    aspectRatio: 16 / 9,
                                    bottomActions: [
                                      CurrentPosition(
                                        controller: screenService.controller!,
                                      ),
                                      ProgressBar(
                                        isExpanded: true,
                                        controller: screenService.controller!,
                                        colors: const ProgressBarColors(
                                          playedColor: Colors.white,
                                          handleColor: Colors.white,
                                        ),
                                      ),
                                      RemainingDuration(
                                        controller: screenService.controller!,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.pushNamed(
                                            context,
                                            fullVideoRoute,
                                            arguments:
                                                screenService.controller!,
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
                                      videoService.suggestionVideos.length,
                                      (index) {
                                        var video = videoService
                                            .suggestionVideos[index];

                                        return VideoWidget(
                                          video: video,
                                          onTap: () {
                                            screenService.setCurrentVideo(
                                              context: context,
                                              video: video,
                                            );
                                            videoService.fetchVideo(
                                                videoID: video.id);
                                            screenService.screentoVideoDetail();
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  _isLoaded
                                      ? SizedBox(
                                          width:
                                              _bannerAd!.size.width.toDouble(),
                                          height:
                                              _bannerAd!.size.height.toDouble(),
                                          child: AdWidget(ad: _bannerAd!),
                                        )
                                      : const SizedBox(
                                          height: 100,
                                          width: double.infinity,
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              color: ConstantColors.whiteColor,
                                            ),
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
          );
        } else {
          return Scaffold(
            backgroundColor: ConstantColors.mainColor,
            body: videoService.isVideoFetching ||
                    screenService.controller == null ||
                    screenService.currentChannelID == null ||
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
                          Text(
                            screenService.currentChannelName!,
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 25),
                          YoutubePlayer(
                            controller: screenService.controller!,
                            showVideoProgressIndicator: true,
                            width: MediaQuery.of(context).size.width,
                            aspectRatio: 16 / 9,
                            bottomActions: [
                              CurrentPosition(
                                controller: screenService.controller!,
                              ),
                              ProgressBar(
                                isExpanded: true,
                                controller: screenService.controller!,
                                colors: const ProgressBarColors(
                                  playedColor: Colors.white,
                                  handleColor: Colors.white,
                                ),
                              ),
                              RemainingDuration(
                                controller: screenService.controller!,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    fullVideoRoute,
                                    arguments: screenService.controller!,
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
                          _isLoaded
                              ? SizedBox(
                                  width: _bannerAd!.size.width.toDouble(),
                                  height: _bannerAd!.size.height.toDouble(),
                                  child: AdWidget(ad: _bannerAd!),
                                )
                              : const SizedBox(
                                  height: 100,
                                  width: double.infinity,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: ConstantColors.whiteColor,
                                    ),
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
                              videoService.suggestionVideos.length,
                              (index) {
                                var video =
                                    videoService.suggestionVideos[index];

                                return VideoWidget(
                                  video: video,
                                  onTap: () {
                                    screenService.setCurrentVideo(
                                      context: context,
                                      video: video,
                                    );
                                    videoService.fetchVideo(videoID: video.id);
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
          );
        }
      },
    );
  }
}
