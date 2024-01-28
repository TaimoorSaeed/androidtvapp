import 'package:androidtvapp/application/model/language_model.dart';
import 'package:androidtvapp/application/service/screen_service.dart';
import 'package:androidtvapp/application/service/video_service.dart';
import 'package:androidtvapp/main.dart';
import 'package:androidtvapp/values/common.dart';
import 'package:androidtvapp/values/constant_colors.dart';
import 'package:androidtvapp/values/path.dart';
import 'package:androidtvapp/widgets/sidebar_card_widget.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Language> languages = [
    Language(
      languageName: "English",
      languageShortCode: "en",
    ),
    Language(
      languageName: "German",
      languageShortCode: "de",
    ),
    Language(
      languageName: "عربي",
      languageShortCode: "hi",
    ),
  ];

  late Language localization;

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
    localization = languages[0];

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
      toastDuration: const Duration(seconds: 5),
      title: Text(
        notification!.body!,
        style: const TextStyle(
          color: Colors.black,
        ),
      ),
      action: Text(
        notification.title!,
        style: const TextStyle(
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
        _scaffoldKey.currentState!.closeDrawer();

        return false;
      },
      child: Scaffold(
        key: _scaffoldKey,
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
              Path.pngLogo,
              width: 120,
            ),
          ),
          actions: [
            DropdownButton<Language>(
              enableFeedback: true,
              iconSize: 16,
              borderRadius: BorderRadius.circular(16),
              style: const TextStyle(),
              dropdownColor: ConstantColors.secondMainColor,
              underline: Container(),
              padding: MediaQuery.of(context).size.width > 650
                  ? const EdgeInsets.only(
                      top: 15,
                      right: 60,
                      left: 60,
                    )
                  : const EdgeInsets.only(
                      top: 15,
                      right: 20,
                      left: 20,
                    ),
              value: localization,
              items: languages
                  .map((language) => DropdownMenuItem(
                        value: language,
                        child: Text(
                          language.languageName,
                        ),
                      ))
                  .toList(),
              onChanged: (val) {
                AndroidTVApp.setLocale(
                  context,
                  Locale(val!.languageShortCode, ''),
                );

                setState(() {
                  localization = val;
                });
              },
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
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      Path.colorLogo,
                      width: 100,
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
                    category: AppLocalizations.of(context)!.tvAndLiveBroadcasts,
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
                    category: AppLocalizations.of(context)!.churches,
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
                    category: AppLocalizations.of(context)!.toons,
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
                    category: AppLocalizations.of(context)!.artists,
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
