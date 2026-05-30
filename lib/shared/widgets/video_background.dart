import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// Video Background Widget
/// Plays a video as the background - looped, muted, full-screen coverage
class VideoBackground extends StatefulWidget {
  final String videoPath;
  final Widget child;

  const VideoBackground({
    Key? key,
    required this.videoPath,
    required this.child,
  }) : super(key: key);

  @override
  State<VideoBackground> createState() => _VideoBackgroundState();
}

class _VideoBackgroundState extends State<VideoBackground> {
  late VideoPlayerController _videoController;
  bool _videoReady = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      _videoController = VideoPlayerController.asset(widget.videoPath);
      await _videoController.initialize();
      await _videoController.setLooping(true);
      await _videoController.setVolume(0); // Mute
      _videoController.play();

      setState(() {
        _videoReady = true;
      });
    } catch (e) {
      print('Error initializing video: $e');
      setState(() {
        _videoReady = false;
      });
    }
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_videoReady) {
      return Stack(
        children: [
          Container(color: Colors.black),
          widget.child,
        ],
      );
    }

    return Stack(
      children: [
        // Video background
        SizedBox.expand(
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: _videoController.value.size.width,
              height: _videoController.value.size.height,
              child: VideoPlayer(_videoController),
            ),
          ),
        ),
        // Dark overlay for better text readability (optional)
        Container(
          color: Colors.black.withOpacity(0.2),
        ),
        // Content on top
        widget.child,
      ],
    );
  }
}
