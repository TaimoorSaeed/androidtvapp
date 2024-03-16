import 'package:androidtvapp/application/service/screen_service.dart';
import 'package:androidtvapp/values/constant_colors.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class LiveStreamScreen extends StatefulWidget {
  const LiveStreamScreen({super.key});

  @override
  State<LiveStreamScreen> createState() => _LiveStreamScreenState();
}

class _LiveStreamScreenState extends State<LiveStreamScreen> {
  @override
  void deactivate() {
    var screenService = Provider.of<ScreenService>(context, listen: false);

    screenService.liveStreamController?.dispose();
    screenService.liveStreamChewieController?.dispose();

    super.deactivate();
  }

  void _onKeyPressed(RawKeyEvent e) {
    var screenService = Provider.of<ScreenService>(context, listen: false);

    if (e.logicalKey == LogicalKeyboardKey.select) {
      screenService.liveStreamChewieController!.enterFullScreen();
    } else if (e.logicalKey == LogicalKeyboardKey.mediaPlayPause) {
      setState(() {
        if (screenService.liveStreamChewieController!.isPlaying) {
          screenService.liveStreamChewieController!.pause();
        } else {
          screenService.liveStreamChewieController!.play();
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
    } else if (e.logicalKey == LogicalKeyboardKey.escape) {
      // Handle escape key press (exit full-screen, for example)
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenService = Provider.of<ScreenService>(context, listen: true);

    return Scaffold(
      backgroundColor: ConstantColors.mainColor,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 30,
        ),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [
              0.1,
              0.7,
            ],
            colors: [
              ConstantColors.secondMainColor,
              ConstantColors.mainColor,
            ],
          ),
        ),
        child: screenService.liveStreamController == null
            ? const Center(
                child: CircularProgressIndicator(
                  color: ConstantColors.whiteColor,
                ),
              )
            : Column(
                children: [
                  RawKeyboardListener(
                    focusNode: FocusNode(),
                    onKey: _onKeyPressed,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Live Broadcasting",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 10),
                        AspectRatio(
                          aspectRatio: screenService
                              .liveStreamController!.value.aspectRatio,
                          child: Chewie(
                            controller:
                                screenService.liveStreamChewieController!,
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
