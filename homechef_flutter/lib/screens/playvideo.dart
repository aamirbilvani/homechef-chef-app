import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:homechefflutter/ui/ChefAppScaffold.dart';

class VideoApp extends StatefulWidget {
  final String video;

  VideoApp({Key key, @required this.video}) : super(key: key);

  @override
  _VideoAppState createState() => _VideoAppState(video);
}

class _VideoAppState extends State<VideoApp> {
  VideoPlayerController _controller;
  String video;

  _VideoAppState(this.video);

  @override
  void initState() {
    super.initState();

    // todo: remove this while building for production
    String samplePortraitVideo = 'https://assets.mixkit.co/videos/preview/mixkit-mysterious-pale-looking-fashion-woman-at-winter-39878-large.mp4';

    _controller = VideoPlayerController.network(video)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {
          _controller.play();
          _controller.setLooping(true);
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    print(video);

    return ChefAppScaffold(
      title: "Video",
      showNotifications: true,
      showBackButton: true,
      showHomeButton: true,
      body: Column(children: [
        Expanded(
          flex: 3,
          child: Center(
            child: _controller.value.initialized
                ? AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            )
                : Container(),
          ),
        ),

        // RaisedButton(
        //   onPressed: () {
        //     setState(() {
        //       _controller.value.isPlaying
        //           ? _controller.pause()
        //           : _controller.play();
        //     });
        //   },
        //   child:
        //     _controller.value.isPlaying ? Image.asset('images/gallery/pauseIcon.png', height:35, width: 35,) : Image.asset('images/gallery/playIcon.png', height:35, width: 35,),
        //   color: Colors.transparent, splashColor: Colors.transparent,
        // ),

        Padding(
          padding: const EdgeInsets.all(16.0),
          child: InkWell(
            child: _controller.value.isPlaying
                ? Image.asset(
                    'images/gallery/pauseIcon.png',
                    height: 60,
                    width: 60,
                  )
                : Image.asset(
                    'images/gallery/playIcon.png',
                    height: 50,
                    width: 50,
                  ),
            splashColor: Colors.transparent,
            onTap: () {
              setState(() {
                _controller.value.isPlaying
                    ? _controller.pause()
                    : _controller.play();
              });
            },
          ),
        )
      ]),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
