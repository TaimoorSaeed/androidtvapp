import 'package:androidtvapp/application/service/screen_service.dart';
import 'package:androidtvapp/application/service/video_service.dart';
import 'package:androidtvapp/values/common.dart';
import 'package:androidtvapp/values/constant_colors.dart';
import 'package:androidtvapp/values/path.dart';
import 'package:androidtvapp/widgets/search_widget.dart';
import 'package:androidtvapp/widgets/sidebar_card_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var common = Provider.of<Common>(context, listen: false);

    var screenService = Provider.of<ScreenService>(context, listen: true);

    return Scaffold(
      backgroundColor: ConstantColors.mainColor,
      appBar: AppBar(
        backgroundColor: ConstantColors.mainColor,
        elevation: 0.0,
        toolbarHeight: 80,
        title: InkWell(
          onTap: () {
            screenService.screentoDashboardScreen();
          },
          child: Image.asset(
            Path.logo,
            width: 120,
          ),
        ),
        actions: const [
          Icon(
            FontAwesomeIcons.magnifyingGlass,
            size: 20,
          ),
          SizedBox(width: 20),
          Icon(
            FontAwesomeIcons.bell,
            size: 20,
          ),
          SizedBox(width: 20),
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.transparent,
            backgroundImage: CachedNetworkImageProvider(
              Path.placeholderImg,
            ),
          ),
          SizedBox(width: 60),
        ],
      ),
      body: screenService.screen,
      drawer: Drawer(
        backgroundColor: ConstantColors.whiteColor,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(0),
          children: [
            DrawerHeader(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: ConstantColors.mainColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Image.asset(
                          Path.logo,
                          width: 60,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.clear_sharp,
                          size: 26,
                          color: ConstantColors.secondMainColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  const SearchWidget()
                ],
              ),
            ),
            ListView.builder(
              itemCount: common.artists.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: ((context, index) {
                var artist = common.artists[index];

                return SideBarCardWidget(
                  thumbnail: artist["thumbnail"],
                  name: artist["name"],
                  onTap: () {
                    _getVideos(
                      channelID: artist["channel_id"],
                      channelName: artist["name"],
                    );

                    Navigator.pop(context);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
