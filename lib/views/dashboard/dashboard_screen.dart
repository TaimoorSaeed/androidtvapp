import 'package:androidtvapp/application/service/screen_service.dart';
import 'package:androidtvapp/application/service/video_service.dart';
import 'package:androidtvapp/utils/constants.dart';
import 'package:androidtvapp/values/common.dart';
import 'package:androidtvapp/values/constant_colors.dart';
import 'package:androidtvapp/values/path.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  _getVideos({
    required String channelID,
    required String channelName,
  }) {
    var videoService = Provider.of<VideoService>(context, listen: false);
    var screenService = Provider.of<ScreenService>(context, listen: false);

    screenService.screentoChannelVideo(
        channelID: channelID, channelName: channelName);

    videoService.fetchBroadcastingVideos(
      channelID: channelID,
    );

    videoService.fetchLatestVideos(
      channelID: channelID,
    );

    videoService.fetchPopularVideos(
      channelID: channelID,
    );
  }

  @override
  Widget build(BuildContext context) {
    var common = Provider.of<Common>(context, listen: false);

    return Scaffold(
      backgroundColor: ConstantColors.mainColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 60, right: 60, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.asset(Path.banner),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, bottom: 20),
                    child: Image.asset(Path.bannerContent),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Text(
                Constants.tvAndLiveBroadCasts,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 110,
                child: GridView(
                  scrollDirection: Axis.horizontal,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 300,
                    childAspectRatio: 1.5 / 2.7,
                    mainAxisSpacing: 12,
                  ),
                  children: common.tvAndLiveBroadcasts
                      .map(
                        (item) => InkWell(
                          onTap: () => _getVideos(
                            channelID: item["channel_id"],
                            channelName: item["name"],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              item["thumbnail"],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: 25),
              const Text(
                Constants.artists,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 110,
                child: GridView(
                  scrollDirection: Axis.horizontal,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 350,
                    childAspectRatio: 1.5 / 1.5,
                    mainAxisSpacing: 20,
                  ),
                  children: common.artists
                      .map(
                        (item) => InkWell(
                          onTap: () => _getVideos(
                            channelID: item["channel_id"],
                            channelName: item["name"],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.asset(
                              item["thumbnail"],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: 25),
              const Text(
                Constants.churches,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 110,
                child: GridView(
                  scrollDirection: Axis.horizontal,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 300,
                    childAspectRatio: 1.5 / 2.7,
                    mainAxisSpacing: 12,
                  ),
                  children: common.churches
                      .map(
                        (item) => InkWell(
                          onTap: () => _getVideos(
                            channelID: item["channel_id"],
                            channelName: item["name"],
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  Path.churchBG,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Text(
                                  item["name"],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: 25),
              const Text(
                Constants.toons,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 110,
                child: GridView(
                  scrollDirection: Axis.horizontal,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 300,
                    childAspectRatio: 1.5 / 2.7,
                    mainAxisSpacing: 12,
                  ),
                  children: common.toons
                      .map(
                        (item) => InkWell(
                          onTap: () => _getVideos(
                            channelID: item["channel_id"],
                            channelName: item["name"],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              item["thumbnail"],
                              fit: BoxFit.cover,
                            ),
                          ),
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
