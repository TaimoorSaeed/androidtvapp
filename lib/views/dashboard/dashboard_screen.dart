import 'package:androidtvapp/application/model/language_model.dart';
import 'package:androidtvapp/application/service/playlist_service.dart';
import 'package:androidtvapp/application/service/screen_service.dart';
import 'package:androidtvapp/application/service/video_service.dart';
import 'package:androidtvapp/main.dart';
import 'package:androidtvapp/values/constant_colors.dart';
import 'package:androidtvapp/values/path.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
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

  _getData() {
    var videoService = Provider.of<VideoService>(context, listen: false);
    var playlistService = Provider.of<PlaylistService>(context, listen: false);

    videoService.fetchLatestVideos();
    playlistService.fetchAllPlaylists();
    playlistService.fetchChannelAllPlaylists();
  }

  @override
  void initState() {
    localization = languages[0];
    _getData();

    super.initState();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(message.notification);
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
    var screenService = Provider.of<ScreenService>(context, listen: true);

    return WillPopScope(
      onWillPop: () async {
        screenService.screentoHomeScreen();
        _scaffoldKey.currentState!.closeDrawer();

        return false;
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: ConstantColors.transparent,
        appBar: AppBar(
          backgroundColor: ConstantColors.whiteColor,
          elevation: 0.0,
          toolbarHeight: 80,
          title: InkWell(
            onTap: () {
              screenService.screentoHomeScreen();
            },
            child: Image.asset(
              Path.logo,
              width: 70,
            ),
          ),
          leading: IconButton(
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            icon: const Icon(
              FontAwesomeIcons.bars,
              color: ConstantColors.black,
            ),
          ),
          actions: [
            DropdownButton<Language>(
              enableFeedback: true,
              iconSize: 16,
              borderRadius: BorderRadius.circular(16),
              style: const TextStyle(
                color: ConstantColors.black,
              ),
              dropdownColor: ConstantColors.whiteColor,
              iconEnabledColor: ConstantColors.black,
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
                      Path.logo,
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
              ListTile(
                splashColor: ConstantColors.secondMainColor,
                focusColor: ConstantColors.secondMainColor,
                title: const Text(
                  "Home",
                  style: TextStyle(
                    color: ConstantColors.black,
                  ),
                ),
                onTap: () {
                  screenService.screentoHomeScreen();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                splashColor: ConstantColors.secondMainColor,
                focusColor: ConstantColors.secondMainColor,
                title: const Text(
                  "Watch Live",
                  style: TextStyle(
                    color: ConstantColors.black,
                  ),
                ),
                onTap: () {
                  screenService.screentoLiveStreamScreen();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                splashColor: ConstantColors.secondMainColor,
                focusColor: ConstantColors.secondMainColor,
                title: const Text(
                  "All Playlists",
                  style: TextStyle(
                    color: ConstantColors.black,
                  ),
                ),
                onTap: () {
                  screenService.screenToAllPlaylist();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                splashColor: ConstantColors.secondMainColor,
                focusColor: ConstantColors.secondMainColor,
                title: const Text(
                  "Donations",
                  style: TextStyle(
                    color: ConstantColors.black,
                  ),
                ),
                onTap: () {
                  screenService
                      .screenToDonations("https://square.link/u/sRuKb1b0");
                  Navigator.pop(context);
                },
              ),
              ListTile(
                splashColor: ConstantColors.secondMainColor,
                focusColor: ConstantColors.secondMainColor,
                title: const Text(
                  "About Suboro TV",
                  style: TextStyle(
                    color: ConstantColors.black,
                  ),
                ),
                onTap: () {
                  screenService.screenToDonations(
                      "https://suborotv.net/api/content/about-suborotv.html");
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
