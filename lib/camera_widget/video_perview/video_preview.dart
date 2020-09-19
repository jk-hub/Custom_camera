import 'dart:io';

import 'package:flutter/material.dart';
import 'package:own_camera/camera_widget/video_perview/video_controls.dart';
import 'package:video_player/video_player.dart';

class VideoPreview extends StatefulWidget {
  const VideoPreview({this.videoPath});

  final String videoPath;
  @override
  _VideoPreviewState createState() => _VideoPreviewState();
}

class _VideoPreviewState extends State<VideoPreview>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _controller = VideoPlayerController.file(
      File(widget.videoPath),
    ) //'storage/emulated/0/Own_Camera_Demo/Media/1599918963063.mp4'
      ..initialize().then(
        (_) {
          setState(() {});
        },
      );
  }

  @override
  void dispose() {
    _animationController?.dispose();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    if (_controller.value.initialized) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: <Widget>[
            ClipRect(
              child: Container(
                color: Colors.black,
                margin: EdgeInsets.only(top: 25),
                child: Transform.scale(
                  scale: _controller.value.aspectRatio / size.aspectRatio,
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 100,
              left: 0,
              right: 0,
              child: VideoControls(
                videoController: _controller,
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.transparent.withOpacity(0.5),
                height: 100.0,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.cancel,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.refresh,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    IconButton(
                        icon: Icon(
                          Icons.check,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.pop(context, widget.videoPath);
                        }),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}
