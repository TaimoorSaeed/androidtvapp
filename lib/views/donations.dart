import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DonationsScreen extends StatefulWidget {
  final String url;

  DonationsScreen({
    super.key,
    required this.url,
  });

  @override
  State<DonationsScreen> createState() => _DonationsScreenState();
}

class _DonationsScreenState extends State<DonationsScreen> {
  // @override
  // Widget build(BuildContext context) {

  @override
  Widget build(BuildContext context) {
    WebViewController webViewController = WebViewController();

    return IndexedStack(
      index: 0,
      children: [
        WebViewWidget(
          controller: webViewController
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
            ..setNavigationDelegate(NavigationDelegate(
              onPageFinished: (String url) {},
            ))
            ..loadRequest(Uri.parse(widget.url)),
        ),
      ],
    );
  }
}
