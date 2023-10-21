import 'package:androidtvapp/application/service/screen_service.dart';
import 'package:androidtvapp/application/service/video_service.dart';
import 'package:androidtvapp/values/constant_colors.dart';
import 'package:androidtvapp/widgets/video_widget.dart';
import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    var screenService = Provider.of<ScreenService>(context, listen: true);
    var videoService = Provider.of<VideoService>(context, listen: true);

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
                padding: const EdgeInsets.only(left: 60, right: 60, bottom: 20),
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
                            width: MediaQuery.of(context).size.width / 2,
                            aspectRatio: 16 / 9,
                            progressColors: const ProgressBarColors(
                              playedColor: Colors.white,
                              handleColor: Colors.white,
                            ),
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
                      width: MediaQuery.of(context).size.width / 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                          const SizedBox(height: 15),
                          Container(
                            height: 100,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: ConstantColors.greyColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Center(
                              child: Text(
                                "Advertisement",
                                style: TextStyle(
                                  color: ConstantColors.black,
                                ),
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
    );
  }
}
