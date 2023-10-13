import 'package:androidtvapp/values/constant_colors.dart';
import 'package:flutter/material.dart';

class VideoDetailScreen extends StatefulWidget {
  const VideoDetailScreen({super.key});

  @override
  State<VideoDetailScreen> createState() => _VideoDetailScreenState();
}

class _VideoDetailScreenState extends State<VideoDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantColors.whiteColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 60, right: 60, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Channel Name",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: ConstantColors.black,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 1.6,
                    width: MediaQuery.of(context).size.width / 2,
                    color: Colors.green,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 100,
                            width: 150,
                            color: Colors.green,
                          ),
                          const SizedBox(width: 10),
                          Container(
                            height: 100,
                            width: 150,
                            color: Colors.green,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Container(
                            height: 100,
                            width: 150,
                            color: Colors.green,
                          ),
                          const SizedBox(width: 10),
                          Container(
                            height: 100,
                            width: 150,
                            color: Colors.green,
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Container(
                        height: 100,
                        width: 310,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: ConstantColors.black,
                          ),
                        ),
                        child: const Center(
                          child: Text("Advertisement"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
