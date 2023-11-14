import 'package:androidtvapp/application/service/screen_service.dart';
import 'package:androidtvapp/application/service/video_service.dart';
import 'package:androidtvapp/main.dart';
import 'package:androidtvapp/values/common.dart';
import 'package:androidtvapp/values/constant_colors.dart';
import 'package:androidtvapp/values/path.dart';
import 'package:androidtvapp/widgets/search_widget.dart';
import 'package:androidtvapp/widgets/sidebar_card_widget.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String localization = "en";

  int currentLBDrawerIndex = -1;
  int currentCDrawerIndex = -1;
  int currentTOONSDrawerIndex = -1;
  int currentARTDrawerIndex = -1;

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

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        _showNotification(message.notification);
        // Handle the notification's content
      }
    });
  }

  void _showNotification(RemoteNotification? notification) {
    CherryToast.info(
      toastDuration: Duration(seconds: 5),
      title: Text(
        notification!.body!,
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      action: Text(
        notification.title!,
        style: TextStyle(
          color: Colors.black,
        ),
      ),
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    var common = Provider.of<Common>(context, listen: false);

    var screenService = Provider.of<ScreenService>(context, listen: true);

    return WillPopScope(
      onWillPop: () async {
        screenService.screentoDashboardScreen();

        return false;
      },
      child: Scaffold(
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
          actions: [
            DropdownButton(
              enableFeedback: true,
              iconSize: 16,
              borderRadius: BorderRadius.circular(16),
              style: const TextStyle(),
              dropdownColor: ConstantColors.secondMainColor,
              underline: Container(),
              padding: MediaQuery.of(context).size.width > 650
                  ? const EdgeInsets.only(top: 15, right: 60)
                  : const EdgeInsets.only(top: 15, right: 20),
              items: const [
                DropdownMenuItem(
                  value: "en",
                  child: Text(
                    "en",
                  ),
                ),
                DropdownMenuItem(
                  value: "de",
                  child: Text(
                    "de",
                  ),
                ),
              ],
              onChanged: (val) {
                AndroidTVApp.setLocale(
                  context,
                  Locale(val!, ''),
                );

                setState(() {
                  localization = val;
                });

                // if (val == "en") {
                //   setState(() {
                //     localization = "English";
                //   });
                // } else {
                //   setState(() {
                //     localization = "German";
                //   });
                // }
              },
              value: localization,
            ),
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
                itemCount: common.tvAndLiveBroadcasts.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: ((context, index) {
                  var item = common.tvAndLiveBroadcasts[index];

                  return SideBarCardWidget(
                    thumbnail: item["thumbnail"],
                    name: item["name"],
                    category: "TV",
                    isFocus: currentLBDrawerIndex == index,
                    onFocusChange: (focusChanged) {
                      setState(() {
                        currentLBDrawerIndex = -1;
                        currentCDrawerIndex = -1;
                        currentTOONSDrawerIndex = -1;
                        currentARTDrawerIndex = -1;
                      });

                      if (focusChanged!) {
                        setState(() {
                          currentLBDrawerIndex = index;
                        });
                      }
                    },
                    onTap: () {
                      _getVideos(
                        channelID: item["channel_id"],
                        channelName: item["name"],
                      );

                      Navigator.pop(context);
                    },
                  );
                }),
              ),
              ListView.builder(
                itemCount: common.churches.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: ((context, index) {
                  var item = common.churches[index];

                  return SideBarCardWidget(
                    thumbnail: Path.churchBG,
                    isFocus: currentCDrawerIndex == index,
                    name: item["name"],
                    category: "Church",
                    onFocusChange: (focusChanged) {
                      setState(() {
                        currentLBDrawerIndex = -1;
                        currentCDrawerIndex = -1;
                        currentTOONSDrawerIndex = -1;
                        currentARTDrawerIndex = -1;
                      });

                      if (focusChanged!) {
                        setState(() {
                          currentCDrawerIndex = index;
                        });
                      }
                    },
                    onTap: () {
                      _getVideos(
                        channelID: item["channel_id"],
                        channelName: item["name"],
                      );

                      Navigator.pop(context);
                    },
                  );
                }),
              ),
              ListView.builder(
                itemCount: common.toons.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: ((context, index) {
                  var item = common.toons[index];

                  return SideBarCardWidget(
                    thumbnail: item["thumbnail"],
                    name: item["name"],
                    category: "Toons",
                    isFocus: currentTOONSDrawerIndex == index,
                    onFocusChange: (focusChanged) {
                      setState(() {
                        currentLBDrawerIndex = -1;
                        currentCDrawerIndex = -1;
                        currentTOONSDrawerIndex = -1;
                        currentARTDrawerIndex = -1;
                      });

                      if (focusChanged!) {
                        setState(() {
                          currentTOONSDrawerIndex = index;
                        });
                      }
                    },
                    onTap: () {
                      _getVideos(
                        channelID: item["channel_id"],
                        channelName: item["name"],
                      );

                      Navigator.pop(context);
                    },
                  );
                }),
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
                    category: "Music",
                    isFocus: currentARTDrawerIndex == index,
                    onFocusChange: (focusChanged) {
                      setState(() {
                        currentLBDrawerIndex = -1;
                        currentCDrawerIndex = -1;
                        currentTOONSDrawerIndex = -1;
                        currentARTDrawerIndex = -1;
                      });

                      if (focusChanged!) {
                        setState(() {
                          currentARTDrawerIndex = index;
                        });
                      }
                    },
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
      ),
    );
  }
}
