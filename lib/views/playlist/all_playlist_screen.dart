import 'package:androidtvapp/application/service/playlist_service.dart';
import 'package:androidtvapp/application/service/screen_service.dart';
import 'package:androidtvapp/values/constant_colors.dart';
import 'package:androidtvapp/widgets/playlist_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllPlaylistScreen extends StatefulWidget {
  const AllPlaylistScreen({super.key});

  @override
  State<AllPlaylistScreen> createState() => _AllPlaylistScreenState();
}

class _AllPlaylistScreenState extends State<AllPlaylistScreen> {
  _loadMoreVideos() {
    Provider.of<PlaylistService>(context, listen: false)
        .fetchChannelAllPlaylistsWithPagination();
  }

  @override
  Widget build(BuildContext context) {
    var screenService = Provider.of<ScreenService>(context);
    var playlistService = Provider.of<PlaylistService>(context);

    return Scaffold(
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
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollDetails) {
            if ((!playlistService.isFetching) &&
                scrollDetails.metrics.pixels ==
                    scrollDetails.metrics.maxScrollExtent &&
                playlistService.nextPageToken != null) {
              print("Hello i am here");
              print(playlistService.nextPageToken);
              _loadMoreVideos();
            }

            return false;
          },
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
                            children: playlistService.allPlaylists
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
                  if (playlistService.isFetching)
                    const Center(
                      child: CircularProgressIndicator(),
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
