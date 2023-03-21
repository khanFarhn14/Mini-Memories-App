import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ShowVideo extends StatefulWidget {
  final String url;
  const ShowVideo({super.key, required this.url});

  @override
  State<ShowVideo> createState() => _ShowVideoState();
}

class _ShowVideoState extends State<ShowVideo> {
  late VideoPlayerController _videoPlayerController;

  Future _initVideoPlayer() async 
  {
    _videoPlayerController = VideoPlayerController.network(widget.url);
    await _videoPlayerController.initialize();
    await _videoPlayerController.setLooping(true);
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder
      (
        future: _initVideoPlayer(),
        builder: (context, state) 
        {
          if (state.connectionState == ConnectionState.waiting) 
          {
            return const Center(child: CircularProgressIndicator());
          } else 
          {
            return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: 
      [
        _videoPlayerController.value.isInitialized ? AspectRatio(aspectRatio: _videoPlayerController.value.aspectRatio,
        child: VideoPlayer(_videoPlayerController)) : Container(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center, 
          children: [

            ElevatedButton(onPressed: (){
              _videoPlayerController.pause();
            }, child: Icon(Icons.pause)),
              Padding(padding: EdgeInsets.all(2)),
             ElevatedButton(onPressed: (){
              _videoPlayerController.play();
            }, child: Icon(Icons.play_arrow))
          ],
        )

      ],
    );
          }
        },
      );
    
    
  }
}