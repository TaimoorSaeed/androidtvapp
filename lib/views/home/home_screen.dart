import 'package:androidtvapp/application/service/playlist_service.dart';
import 'package:androidtvapp/application/service/screen_service.dart';
import 'package:androidtvapp/application/service/video_service.dart';
import 'package:androidtvapp/values/constant_colors.dart';
import 'package:androidtvapp/widgets/playlist_widget.dart';
import 'package:androidtvapp/widgets/video_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    _getData();
    super.initState();
  }

  _getData() {
    var videoService = Provider.of<VideoService>(context, listen: false);
    var playlistService = Provider.of<PlaylistService>(context, listen: false);

    videoService.fetchLatestVideos();
    playlistService.fetchAllPlaylists();
  }

  @override
  Widget build(BuildContext context) {
    var screenService = Provider.of<ScreenService>(context);
    var videoService = Provider.of<VideoService>(context);
    var playlistService = Provider.of<PlaylistService>(context);

    return Scaffold(
      // backgroundColor: ConstantColors.mainColor,
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
        child: SingleChildScrollView(
          child: Padding(
            padding: MediaQuery.of(context).size.width > 650
                ? const EdgeInsets.only(
                    left: 60,
                    right: 60,
                    bottom: 20,
                    top: 30,
                  )
                : const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
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
                  height: 190,
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
                                    print("AAA");
                                    print(context);

                                    screenService.setCurrentVideo(
                                      context: context,
                                      videoId: latestVideo.id,
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
                const Text(
                  "Playlist",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 10),
                Flexible(
                  fit: FlexFit.loose,
                  // width: double.infinity,
                  // height: 180,
                  child: playlistService.isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: ConstantColors.whiteColor,
                          ),
                        )
                      : GridView(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 250,
                            childAspectRatio: 2 / 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          children: playlistService.playlists
                              .map(
                                (playlist) => PlaylistWidget(
                                  playlist: playlist,
                                  onTap: () {
                                    screenService.screentoPlaylistVideoDetail(
                                      videoId: playlist.id,
                                      playlistId: playlist.id,
                                    );
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
      ),
    );
  }
}
