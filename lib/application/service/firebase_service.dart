// ignore_for_file: avoid_print

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class FirebaseService extends ChangeNotifier {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future<void> initNotification() async {
    await messaging.requestPermission();
    // if (Platform.isIOS) {
    final fcmToken = await messaging.getAPNSToken();
    print("Token: $fcmToken");
    // } else {
    // final fcmToken = await messaging.getToken();
    // print("Token: $fcmToken");
    // }
  }
}
