import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void nextScreen(context, page)
{
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

//Replace the Next Screen
void nextScreenReplace(context, page)
{
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => page));
}


class VideoPreview extends StatefulWidget 
{
  final String filePath;
  const VideoPreview({super.key, required this.filePath});

  @override
  State<VideoPreview> createState() => _VideoPreviewState();
}

class _VideoPreviewState extends State<VideoPreview> 
{
  late String videoName;
  late VideoPlayerController _videoPlayerController;

  @override
  void dispose() 
  {
    _videoPlayerController.dispose();
    super.dispose();
  }

  Future _initVideoPlayer() async 
  {
    _videoPlayerController = VideoPlayerController.file(File(widget.filePath));
    await _videoPlayerController.initialize();
    await _videoPlayerController.setLooping(true);
    await _videoPlayerController.play();
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox
    (
      height: 500,
      child: VideoPlayer(_videoPlayerController,)
    );
  }
}