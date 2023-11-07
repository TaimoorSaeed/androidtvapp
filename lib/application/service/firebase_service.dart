// ignore_for_file: avoid_print

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FirebaseService extends ChangeNotifier {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future<void> initNotification() async {
    await messaging.requestPermission();
    final fcmToken = await messaging.getToken();

    print("Token: $fcmToken");
  }
}
