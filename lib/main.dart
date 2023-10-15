import 'package:androidtvapp/application/service/channel_service.dart';
import 'package:androidtvapp/application/service/screen_service.dart';
import 'package:androidtvapp/router/route_constant.dart';
import 'package:androidtvapp/router/routers.dart';
import 'package:androidtvapp/values/branding_color.dart';
import 'package:androidtvapp/values/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const AndroidTVApp());
}

class AndroidTVApp extends StatelessWidget {
  const AndroidTVApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Common()),

        // Service Provider
        ChangeNotifierProvider(create: (_) => ScreenService()),
        ChangeNotifierProvider(create: (_) => ChannelService()),

        // Helper Provider
      ],
      child: Shortcuts(
        shortcuts: <LogicalKeySet, Intent>{
          LogicalKeySet(LogicalKeyboardKey.select): const ActivateIntent(),
        },
        child: MaterialApp(
          title: 'Android TV App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
            ).fontFamily,
            primarySwatch: brandingColor,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          onGenerateRoute: Routers.onGenerateRoute,
          initialRoute: homeRoute,
        ),
      ),
    );
  }
}
