import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoDisplay extends StatefulWidget {
  final String videoUrl;

  VideoDisplay({required this.videoUrl});

  @override
  _VideoDisplayState createState() => _VideoDisplayState();
}

class _VideoDisplayState extends State<VideoDisplay> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();

    // Initialize the controller with the provided video URL
    _controller = VideoPlayerController.network(widget.videoUrl);
    _controller.play();

    // Initialize the video player
    _initializeVideoPlayerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose the controller when not needed
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (_controller.value.isPlaying) {
            _controller.pause();
          } else {
            _controller.play();
          }
        });
      },
      child: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the video is ready, display it
            return AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            );
          } else {
            // Display a loading indicator while the video is being initialized
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
