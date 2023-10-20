import 'package:androidtvapp/application/model/channel_model.dart';
import 'package:androidtvapp/application/service/channel_service.dart';
import 'package:androidtvapp/application/service/screen_service.dart';
import 'package:androidtvapp/application/service/video_service.dart';
import 'package:androidtvapp/values/constant_colors.dart';
import 'package:androidtvapp/values/path.dart';
import 'package:androidtvapp/views/dashboard/dashboard_screen.dart';
import 'package:androidtvapp/widgets/search_widget.dart';
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
    required Channel channel,
  }) {
    var videoService = Provider.of<VideoService>(context, listen: false);
    Provider.of<ScreenService>(context, listen: false).currentVideoChannel =
        channel;

    videoService.fetchBroadcastingVideos(
      channelID: channel.id,
    );

    videoService.fetchLatestVideos(
      channelID: channel.id,
    );

    videoService.fetchPopularVideos(
      channelID: channel.id,
    );
  }

  @override
  void initState() {
    Provider.of<ChannelService>(context, listen: false)
        .fetchChannels()
        .then((value) {
      if (value != null) {
        _getVideos(channel: value[0]);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenService = Provider.of<ScreenService>(context, listen: true);
    var channelService = Provider.of<ChannelService>(context, listen: true);

    return Scaffold(
      backgroundColor: ConstantColors.mainColor,
      appBar: AppBar(
        backgroundColor: ConstantColors.mainColor,
        elevation: 0.0,
        toolbarHeight: 80,
        title: Image.asset(
          Path.logo,
          width: 120,
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
      body: channelService.isFetching
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : screenService.screen,
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
                      Image.asset(
                        Path.colorLogo,
                        width: 130,
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
            channelService.isFetching
                ? const Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: ConstantColors.black,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: channelService.channels.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: ((context, index) {
                      var channel = channelService.channels[index];

                      return ListTile(
                        leading: CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.transparent,
                          backgroundImage: CachedNetworkImageProvider(
                            channel.profilePictureUrl,
                          ),
                        ),
                        title: Text(
                          channel.title,
                          style: TextStyle(
                            color: ConstantColors.black,
                          ),
                        ),
                        onTap: () {
                          _getVideos(channel: channel);

                          Navigator.pop(context);
                          screenService.screentoChannelVideo(
                            channel: channel,
                          );
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
