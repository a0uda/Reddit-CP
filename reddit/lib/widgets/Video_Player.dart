import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late CustomVideoPlayerController _customVideoPlayerController;
  late VideoPlayerController _videocontroller;

  @override
  void initState() {
    super.initState();
    _videocontroller = VideoPlayerController.networkUrl(Uri.parse(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'))
      ..initialize().then((value) => {});
    _customVideoPlayerController = CustomVideoPlayerController(
        context: context, videoPlayerController: _videocontroller);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _videocontroller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _videocontroller.value.aspectRatio,
                // Use the VideoPlayer widget to display the video
                child: CustomVideoPlayer(
                    customVideoPlayerController: _customVideoPlayerController),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
