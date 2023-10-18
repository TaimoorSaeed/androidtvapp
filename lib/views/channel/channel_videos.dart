import 'package:androidtvapp/application/service/screen_service.dart';
import 'package:androidtvapp/application/service/video_service.dart';
import 'package:androidtvapp/values/constant_colors.dart';
import 'package:androidtvapp/widgets/video_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChannelVideos extends StatefulWidget {
  const ChannelVideos({
    super.key,
  });

  @override
  State<ChannelVideos> createState() => _ChannelVideosState();
}

class _ChannelVideosState extends State<ChannelVideos>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    var screenService = Provider.of<ScreenService>(context, listen: true);
    var videoService = Provider.of<VideoService>(context, listen: true);

    return Scaffold(
      backgroundColor: ConstantColors.whiteColor,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(
              color: ConstantColors.black,
            ),
          ),
          child: const Center(
            child: Text("Advertisement"),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 60, right: 60, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Live Broadcasting",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: ConstantColors.black,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 110,
                child: videoService.isBroadcastVideosFetching
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: ConstantColors.black,
                        ),
                      )
                    : GridView(
                        scrollDirection: Axis.horizontal,
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 300,
                          childAspectRatio: 1.5 / 2,
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
              const Text(
                "Latest Videos",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: ConstantColors.black,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 110,
                child: videoService.isLatestVideosFetching
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: ConstantColors.black,
                        ),
                      )
                    : GridView(
                        scrollDirection: Axis.horizontal,
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 300,
                          childAspectRatio: 1.5 / 2,
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
              const Text(
                "Most viewed",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: ConstantColors.black,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 110,
                child: videoService.isPopularVideosFetching
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: ConstantColors.black,
                        ),
                      )
                    : GridView(
                        scrollDirection: Axis.horizontal,
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 300,
                          childAspectRatio: 1.5 / 2,
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
