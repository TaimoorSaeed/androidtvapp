import 'package:androidtvapp/application/service/screen_service.dart';
import 'package:androidtvapp/values/constant_colors.dart';
import 'package:androidtvapp/values/path.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    var screenService = Provider.of<ScreenService>(context, listen: true);

    return Scaffold(
      backgroundColor: ConstantColors.whiteColor,
      appBar: AppBar(
        elevation: 0.0,
        toolbarHeight: 100,
        title: Image.asset(
          Path.logo,
          width: 200,
        ),
      ),
      body: screenService.screen,
      drawer: Drawer(
        backgroundColor: ConstantColors.whiteColor,
        child: ListView(
          padding: const EdgeInsets.all(0),
          children: [
            DrawerHeader(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  Path.logo,
                ),
                Text(
                  "Channels",
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    color: ConstantColors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            )), //DrawerHeader
            ListTile(
              leading: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.transparent,
                backgroundImage: CachedNetworkImageProvider(
                  Path.placeholderImg,
                ),
              ),
              title: const Text('Reality TV'),
              onTap: () {
                Navigator.pop(context);
                screenService.screentoChannelVideo();
              },
            ),
            ListTile(
              leading: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.transparent,
                backgroundImage: CachedNetworkImageProvider(
                  Path.placeholderImg,
                ),
              ),
              title: const Text('Reality TV'),
              onTap: () {
                Navigator.pop(context);
                screenService.screentoChannelVideo();
              },
            ),
            ListTile(
              leading: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.transparent,
                backgroundImage: CachedNetworkImageProvider(
                  Path.placeholderImg,
                ),
              ),
              title: const Text('Reality TV'),
              onTap: () {
                Navigator.pop(context);
                screenService.screentoChannelVideo();
              },
            ),
            ListTile(
              leading: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.transparent,
                backgroundImage: CachedNetworkImageProvider(
                  Path.placeholderImg,
                ),
              ),
              title: const Text('Reality TV'),
              onTap: () {
                Navigator.pop(context);
                screenService.screentoChannelVideo();
              },
            ),
            ListTile(
              leading: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.transparent,
                backgroundImage: CachedNetworkImageProvider(
                  Path.placeholderImg,
                ),
              ),
              title: const Text('Reality TV'),
              onTap: () {
                Navigator.pop(context);
                screenService.screentoChannelVideo();
              },
            ),
            ListTile(
              leading: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.transparent,
                backgroundImage: CachedNetworkImageProvider(
                  Path.placeholderImg,
                ),
              ),
              title: const Text('Reality TV'),
              onTap: () {
                Navigator.pop(context);
                screenService.screentoChannelVideo();
              },
            ),
          ],
        ),
      ),
    );
  }
}
