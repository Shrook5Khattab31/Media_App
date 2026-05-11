import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PlayerScreen extends StatefulWidget {
  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late VideoPlayerController controller;

  List<Map<String, String>> mediaList = [
    {
      "path": "assets/video.mp4",
      "thumb": "assets/top1.jpg",
      "title": "Main App Refactor",
      "type": "video",
    },
    {
      "path": "assets/video1.mov",
      "thumb": "assets/top2.jpg",
      "title": "UI Design",
      "type": "video",
    },
    {
      "path": "assets/audio.wav",
      "thumb": "assets/top3.jpg",
      "title": "Podcast Audio",
      "type": "audio",
    },
  ];

  Map<String, String>? currentMedia;

  @override
  void initState() {
    super.initState();
    currentMedia = mediaList[0];
    initMedia(currentMedia!);
    startUpdater();
  }

  void initMedia(Map<String, String> item) {
    controller = VideoPlayerController.asset(item["path"]!)
      ..initialize().then((_) {
        setState(() {});
        controller.play();
      });
  }

  void changeMedia(Map<String, String> item) async {
    await controller.pause();
    await controller.dispose();
    currentMedia = item;
    initMedia(item);
  }

  void startUpdater() {
    Future.doWhile(() async {
      await Future.delayed(Duration(milliseconds: 300));
      if (!mounted) return false;
      if (controller.value.isPlaying) setState(() {});
      return true;
    });
  }

  void forward() {
    final newPos = controller.value.position + Duration(seconds: 10);
    controller.seekTo(newPos);
  }

  void backward() {
    final newPos = controller.value.position - Duration(seconds: 10);

    controller.seekTo(newPos < Duration.zero ? Duration.zero : newPos);
  }

  String format(Duration d) {
    String two(int n) => n.toString().padLeft(2, "0");
    return "${two(d.inMinutes)}:${two(d.inSeconds % 60)}";
  }

  @override
  Widget build(BuildContext context) {
    double position = controller.value.isInitialized
        ? controller.value.position.inSeconds.toDouble()
        : 0;

    double duration =
        controller.value.isInitialized &&
            controller.value.duration.inSeconds > 0
        ? controller.value.duration.inSeconds.toDouble()
        : 1;

    return Scaffold(
      backgroundColor: Color(0xFF0B1220),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 10),

            // 🔥 PLAYER
            if (controller.value.isInitialized)
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black,
                ),
                child: Column(
                  children: [
                    currentMedia!["type"] == "video"
                        ? AspectRatio(
                            aspectRatio: controller.value.aspectRatio,
                            child: VideoPlayer(controller),
                          )
                        : Container(
                            height: 200,
                            child: Center(
                              child: Icon(
                                Icons.music_note,
                                size: 80,
                                color: Colors.white,
                              ),
                            ),
                          ),

                    Slider(
                      value: position,
                      max: duration,
                      onChanged: (v) {
                        controller.seekTo(Duration(seconds: v.toInt()));
                      },
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          format(controller.value.position),
                          style: TextStyle(color: Colors.white70),
                        ),
                        Text(
                          format(controller.value.duration),
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          onPressed: backward,
                          icon: Icon(Icons.replay_10, color: Colors.white),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              controller.value.isPlaying
                                  ? controller.pause()
                                  : controller.play();
                            });
                          },
                          icon: Icon(
                            controller.value.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          onPressed: forward,
                          icon: Icon(Icons.forward_10, color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            SizedBox(height: 15),

            // 🔥 Recently Played
            SizedBox(
              height: 140,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: mediaList.length,
                itemBuilder: (_, i) {
                  final item = mediaList[i];
                  return GestureDetector(
                    onTap: () => changeMedia(item),
                    child: Container(
                      width: 220,
                      margin: EdgeInsets.only(left: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image: AssetImage(item["thumb"]!),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.play_circle_fill,
                          color: Colors.white,
                          size: 60,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 10),

            // 🔥 Up Next
            Expanded(
              child: ListView.builder(
                itemCount: mediaList.length,
                itemBuilder: (_, i) {
                  final item = mediaList[i];
                  return GestureDetector(
                    onTap: () => changeMedia(item),
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            item["thumb"]!,
                            width: 80,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              item["title"]!,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Icon(Icons.play_arrow, color: Colors.white),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
