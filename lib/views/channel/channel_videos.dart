import 'dart:io';
import 'package:androidtvapp/application/service/screen_service.dart';
import 'package:androidtvapp/application/service/video_service.dart';
import 'package:androidtvapp/values/constant_colors.dart';
import 'package:androidtvapp/widgets/video_widget.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChannelVideos extends StatefulWidget {
  const ChannelVideos({
    super.key,
  });

  @override
  State<ChannelVideos> createState() => _ChannelVideosState();
}

class _ChannelVideosState extends State<ChannelVideos>
    with SingleTickerProviderStateMixin {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  final adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-3940256099942544/2934735716';

  late VideoPlayerController _controller;
  ChewieController? _chewieController;

  void loadAd() {
    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      size: AdSize.fullBanner,
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

  _initPlayer() async {
    var screenService = Provider.of<ScreenService>(context, listen: false);

    if (screenService.currentChannelName == "Suboro TV") {
      _controller = VideoPlayerController.network(
        'http://fs4.suboroiptv.tv/suboromain/live/index.m3u8',
      );

      await _controller.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _controller,
        autoPlay: true,
      );

      setState(() {});
    }
  }

  @override
  void initState() {
    loadAd();
    _initPlayer();

    super.initState();
  }

  @override
  void deactivate() {
    var screenService = Provider.of<ScreenService>(context, listen: false);

    if (screenService.currentChannelName == "Suboro TV") {
      _controller.dispose();
      _chewieController?.dispose();
    }

    super.deactivate();
  }

  void _onKeyPressed(RawKeyEvent e) {
    if (e.runtimeType.toString() == 'RawKeyDownEvent') {
      switch (e.logicalKey.debugName) {
        case 'Media Play Pause':
        case 'Select':
          setState(() {
            if (_chewieController!.isPlaying) {
              _chewieController!.pause();
            } else {
              _chewieController!.play();
            }
          });
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenService = Provider.of<ScreenService>(context, listen: true);
    var videoService = Provider.of<VideoService>(context, listen: true);

    return Scaffold(
      backgroundColor: ConstantColors.mainColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: MediaQuery.of(context).size.width > 650
              ? const EdgeInsets.only(left: 60, right: 60, bottom: 20)
              : const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (screenService.currentChannelName == "Suboro TV")
                RawKeyboardListener(
                  focusNode: FocusNode(),
                  onKey: _onKeyPressed,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.watchLive,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (_chewieController != null)
                        AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: Chewie(
                            controller: _chewieController!,
                          ),
                        ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              if (videoService.broadcastingVideos.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.liveBroadcasting,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 180,
                      child: videoService.isBroadcastVideosFetching
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: ConstantColors.whiteColor,
                              ),
                            )
                          : GridView(
                              scrollDirection: Axis.horizontal,
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 250,
                                childAspectRatio: 2 / 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                              ),
                              children: videoService.broadcastingVideos
                                  .map(
                                    (broadcastVideo) => VideoWidget(
                                      video: broadcastVideo,
                                      onTap: () {
                                        screenService.setCurrentVideo(
                                          context: context,
                                          video: broadcastVideo,
                                        );

                                        videoService.fetchVideo(
                                            videoID: broadcastVideo.id);
                                        screenService.screentoVideoDetail();
                                      },
                                    ),
                                  )
                                  .toList(),
                            ),
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              Text(
                AppLocalizations.of(context)!.latestVideos,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 180,
                child: videoService.isLatestVideosFetching
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: ConstantColors.whiteColor,
                        ),
                      )
                    : GridView(
                        scrollDirection: Axis.horizontal,
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 250,
                          childAspectRatio: 2 / 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        children: videoService.latestVideos
                            .map(
                              (latestVideo) => VideoWidget(
                                video: latestVideo,
                                onTap: () {
                                  screenService.setCurrentVideo(
                                    context: context,
                                    video: latestVideo,
                                  );
                                  videoService.fetchVideo(
                                      videoID: latestVideo.id);
                                  screenService.screentoVideoDetail();
                                },
                              ),
                            )
                            .toList(),
                      ),
              ),
              const SizedBox(height: 15),
              _isLoaded
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: SizedBox(
                            width: _bannerAd!.size.width.toDouble(),
                            height: _bannerAd!.size.height.toDouble(),
                            child: AdWidget(ad: _bannerAd!),
                          ),
                        ),
                      ],
                    )
                  : SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 60,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: ConstantColors.whiteColor,
                        ),
                      ),
                    ),
              const SizedBox(height: 15),
              Text(
                AppLocalizations.of(context)!.mostViewed,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 180,
                child: videoService.isPopularVideosFetching
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: ConstantColors.whiteColor,
                        ),
                      )
                    : GridView(
                        scrollDirection: Axis.horizontal,
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 250,
                          childAspectRatio: 2 / 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        children: videoService.popularVideos
                            .map(
                              (popularVideo) => VideoWidget(
                                video: popularVideo,
                                onTap: () {
                                  screenService.setCurrentVideo(
                                    context: context,
                                    video: popularVideo,
                                  );
                                  videoService.fetchVideo(
                                      videoID: popularVideo.id);
                                  screenService.screentoVideoDetail();
                                },
                              ),
                            )
                            .toList(),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
