import 'package:androidtvapp/application/service/screen_service.dart';
import 'package:androidtvapp/values/constant_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChannelVideos extends StatefulWidget {
  const ChannelVideos({super.key});

  @override
  State<ChannelVideos> createState() => _ChannelVideosState();
}

class _ChannelVideosState extends State<ChannelVideos>
    with SingleTickerProviderStateMixin {
  List<int> cont = [1, 2, 3, 4, 5, 6, 7, 8, 9];

  @override
  Widget build(BuildContext context) {
    var screenService = Provider.of<ScreenService>(context, listen: true);

    return Scaffold(
      backgroundColor: ConstantColors.whiteColor,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(
              color: ConstantColors.black,
            ),
          ),
          child: const Center(
            child: Text("Advertisement"),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 60, right: 60, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Live Broadcasting",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: ConstantColors.black,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 110,
                child: GridView(
                  scrollDirection: Axis.horizontal,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 300,
                    childAspectRatio: 1.5 / 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  children: cont
                      .map((e) => InkWell(
                            onTap: () {
                              screenService.screentoVideoDetail();
                            },
                            child: Container(
                              height: 200,
                              width: 200,
                              color: Colors.green,
                            ),
                          ))
                      .toList(),
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                "Latest Videos",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: ConstantColors.black,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 110,
                child: GridView(
                  scrollDirection: Axis.horizontal,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 300,
                    childAspectRatio: 1.5 / 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  children: cont
                      .map((e) => InkWell(
                            onTap: () {
                              screenService.screentoVideoDetail();
                            },
                            child: Container(
                              height: 200,
                              width: 200,
                              color: Colors.green,
                            ),
                          ))
                      .toList(),
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                "Most viewed",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: ConstantColors.black,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 110,
                child: GridView(
                  scrollDirection: Axis.horizontal,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 300,
                    childAspectRatio: 1.5 / 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  children: cont
                      .map((e) => InkWell(
                            onTap: () {
                              screenService.screentoVideoDetail();
                            },
                            child: Container(
                              height: 200,
                              width: 200,
                              color: Colors.green,
                            ),
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
