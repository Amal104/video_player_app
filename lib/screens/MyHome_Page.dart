import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:better_player/better_player.dart';
import 'package:get/get.dart';
import 'package:no_screenshot/no_screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player_app/CustomWidgets/Custom_flushBar.dart';
import 'package:video_player_app/constants.dart';
import 'package:video_player_app/screens/Profile_Screen.dart';

import '../widgets/AppDrawer.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late BetterPlayerController _betterPlayerController;

  final List<String> videoUrls = [
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4',
    'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
  ];

  int _currentIndex = 1;

  void _onVideoIndexChanged(int newIndex) {
    setState(() {
      _currentIndex = newIndex;
    });
  }

  void _downloadVideo(String url) async {
    Dio dio = Dio();
    try {
      var dir = await getApplicationDocumentsDirectory();
      String fileName = '${url.split('=').last}.mp4';
      String filePath = '${dir.path}/$fileName';
      await dio.download(
        url,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            if (kDebugMode) {
              print("${(received / total * 100).toStringAsFixed(0)}%");
            }
          }
        },
      );
      ScaffoldMessenger.of(context).showSnackBar(CustomFlushBar.customFlushBar(
          context, "Success", "Download completed"));
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Download failed")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    NoScreenshot.instance
        .screenshotOff()
        .then((value) => print('Screenshots disabled'))
        .catchError((e) => print('Error disabling screenshots: $e'));
    BetterPlayerConfiguration betterPlayerConfiguration =
        const BetterPlayerConfiguration(
      autoPlay: false,
      controlsConfiguration: BetterPlayerControlsConfiguration(
        enablePlayPause: true,
      ),
    );
    BetterPlayerDataSource dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      videoUrls[_currentIndex],
    );
    _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
    _betterPlayerController.setupDataSource(dataSource);
  }

  @override
  void dispose() {
    _betterPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        drawer: const AppDrawer(),
        appBar: AppBar(
          leading: Builder(builder: (context) {
            return InkWell(
              onTap: () => Scaffold.of(context).openDrawer(),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 4,
                      width: 16,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 3),
                      height: 4,
                      width: 20,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    Container(
                      height: 4,
                      width: 25,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          backgroundColor: Colors.transparent,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: GestureDetector(
                onTap: () {
                  Get.to(() => const ProfileScreen(),
                      transition: Transition.rightToLeft);
                },
                child: const CircleAvatar(
                  backgroundImage: NetworkImage(
                    profileImage,
                  ),
                ),
              ),
            )
          ],
        ),
        body: Column(
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: BetterPlayer(
                controller: _betterPlayerController,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.keyboard_arrow_left),
                      onPressed: _currentIndex > 0
                          ? () {
                              _onVideoIndexChanged(_currentIndex - 1);
                            }
                          : null,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _downloadVideo(videoUrls[_currentIndex]);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.arrow_drop_down,
                            color: Colors.green,
                          ),
                          Text('Download'),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.keyboard_arrow_right),
                      onPressed: _currentIndex < videoUrls.length - 1
                          ? () {
                              _onVideoIndexChanged(_currentIndex + 1);
                            }
                          : null,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
