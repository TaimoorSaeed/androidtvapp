import 'dart:io';

import 'package:androidtvapp/application/service/screen_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class FullVideoScreen extends StatefulWidget {
  const FullVideoScreen({
    super.key,
    required this.controller,
  });

  final YoutubePlayerController controller;

  @override
  State<FullVideoScreen> createState() => _FullVideoScreenState();
}

class _FullVideoScreenState extends State<FullVideoScreen> {
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
      ]);
    }
  }

  @override
  dispose() {
    if (Platform.isAndroid) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }

    super.dispose();
  }

  void _onKeyPressed(RawKeyEvent e) {
    print("Event: $e");

    var screenService = Provider.of<ScreenService>(context, listen: false);

    if (e.logicalKey == LogicalKeyboardKey.select) {
    } else if (e.logicalKey == LogicalKeyboardKey.mediaPlayPause) {
      setState(() {
        if (screenService.videoController!.value.isPlaying) {
          screenService.videoController!.pause();
        } else {
          screenService.videoController!.play();
        }
      });
    } else if (e.logicalKey == LogicalKeyboardKey.arrowUp) {
      // Handle arrow up key press
    } else if (e.logicalKey == LogicalKeyboardKey.arrowDown) {
      // Handle arrow down key press
    } else if (e.logicalKey == LogicalKeyboardKey.arrowLeft) {
      // Handle arrow left key press
    } else if (e.logicalKey == LogicalKeyboardKey.arrowRight) {
      // Handle arrow right key press
    } else if (e.logicalKey == LogicalKeyboardKey.enter) {
      // Handle enter key press
    } else if (e.logicalKey == LogicalKeyboardKey.goBack) {
      Navigator.pop(context);
    }

    // if (e.runtimeType.toString() == 'RawKeyDownEvent') {
    //   switch (e.logicalKey.debugName) {
    //     case 'Media Play Pause':
    //     case 'Select':
    //       setState(() {
    //         if (screenService.controller!.value.isPlaying) {
    //           screenService.controller!.pause();
    //         } else {
    //           screenService.controller!.play();
    //         }
    //       });
    //       break;
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      onKey: _onKeyPressed,
      child: Scaffold(
        body: YoutubePlayer(
          controller: widget.controller,
          showVideoProgressIndicator: true,
          width: MediaQuery.of(context).size.width,
          // aspectRatio: 16 / 9,
          bottomActions: [
            CurrentPosition(
              controller: widget.controller,
            ),
            ProgressBar(
              isExpanded: true,
              controller: widget.controller,
              colors: const ProgressBarColors(
                playedColor: Colors.white,
                handleColor: Colors.white,
              ),
            ),
            RemainingDuration(
              controller: widget.controller,
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.fullscreen_exit,
              ),
            )
          ],
        ),
      ),
    );
  }
}
