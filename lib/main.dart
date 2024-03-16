// ignore_for_file: avoid_print
import 'package:androidtvapp/application/service/firebase_service.dart';
import 'package:androidtvapp/application/service/playlist_service.dart';
import 'package:androidtvapp/application/service/screen_service.dart';
import 'package:androidtvapp/application/service/video_service.dart';
import 'package:androidtvapp/router/route_constant.dart';
import 'package:androidtvapp/router/routers.dart';
import 'package:androidtvapp/values/branding_color.dart';
import 'package:androidtvapp/values/common.dart';
import 'package:androidtvapp/values/constant_colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await Firebase.initializeApp();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey:
          "AIzaSyDwjKJnjTDY9lNGrkwnXSNHg5QLuilu-Fs", // paste your api key here
      appId:
          "1:28674801231:android:12b495aa74aa13b842f43a", //paste your app id here
      messagingSenderId: "28674801231", //paste your messagingSenderId here
      projectId: "suborotvapp", //paste your project id here
    ),
  );
  await FirebaseService().initNotification();

  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  print(Firebase.apps[0].options.authDomain);

  // MobileAds.instance.initialize();

  runApp(const AndroidTVApp());
}

class AndroidTVApp extends StatefulWidget {
  const AndroidTVApp({super.key});

  @override
  State<AndroidTVApp> createState() => _AndroidTVAppState();

  static void setLocale(BuildContext context, Locale newLocale) {
    _AndroidTVAppState? state =
        context.findRootAncestorStateOfType<_AndroidTVAppState>();
    state?.setLocale(newLocale);
  }
}

class _AndroidTVAppState extends State<AndroidTVApp> {
  Locale? _locale;

  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void initState() {
    setState(() {
      _locale = Locale('en', '');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Common()),

        // Service Provider
        ChangeNotifierProvider(create: (_) => ScreenService()),
        ChangeNotifierProvider(create: (_) => VideoService()),
        ChangeNotifierProvider(create: (_) => PlaylistService()),

        // Helper Provider
      ],
      child: Shortcuts(
        shortcuts: <LogicalKeySet, Intent>{
          LogicalKeySet(LogicalKeyboardKey.select): const ActivateIntent(),
        },
        child: MaterialApp(
          title: 'Suboro TV',
          debugShowCheckedModeBanner: false,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          // localizationsDelegates: [
          //   GlobalMaterialLocalizations.delegate,
          //   GlobalWidgetsLocalizations.delegate,
          //   GlobalCupertinoLocalizations.delegate,
          // ],
          // supportedLocales: [
          //   Locale('en'),
          //   Locale('de'),
          //   Locale('hi'),
          // ],
          locale: _locale,

          theme: ThemeData(
            fontFamily: GoogleFonts.inter(
              fontWeight: FontWeight.w500,
            ).fontFamily,
            primarySwatch: brandingColor,
            brightness: Brightness.dark,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            focusColor: ConstantColors.mainColor.withOpacity(0.3),
          ),
          onGenerateRoute: Routers.onGenerateRoute,
          initialRoute: homeRoute,
        ),
      ),
    );
  }
}
