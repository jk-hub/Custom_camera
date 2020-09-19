import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:own_camera/camera_widget/camera_perview/camera_perview.dart';
import 'package:own_camera/camera_widget/video_perview/video_preview.dart';
import 'package:own_camera/camera_widget/video_timer.dart';
import 'package:own_camera/globals.dart' as globals;
import 'package:path_provider/path_provider.dart';

class CameraScreen extends StatefulWidget {
  final type;
  CameraScreen(this.type, {Key key}) : super(key: key);

  @override
  CameraScreenState createState() => CameraScreenState();
}

class CameraScreenState extends State<CameraScreen>
    with AutomaticKeepAliveClientMixin {
  CameraController _controller;
  List<CameraDescription> _cameras;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isRecording = false;
  var videoPath;
  final _timerKey = GlobalKey<VideoTimerState>();

  @override
  void initState() {
    _initCamera();
    super.initState();
  }

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    _controller = CameraController(_cameras[0], ResolutionPreset.high);
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // if (_controller != null) {
    //   if (!_controller.value.isInitialized) {
    //     return Container();
    //   }
    // } else {
    //   return const Center(
    //     child: SizedBox(
    //       width: 32,
    //       height: 32,
    //       child: CircularProgressIndicator(),
    //     ),
    //   );
    // }

    // if (!_controller.value.isInitialized) {
    //   return Container();
    // }
    return Scaffold(
      backgroundColor: Colors.black,
      key: _scaffoldKey,
      extendBody: true,
      body: _controller == null || !_controller.value.isInitialized
          ? Stack(children: <Widget>[
              Center(
                child: SizedBox(
                  width: 32,
                  height: 32,
                  child: CircularProgressIndicator(),
                ),
              ),
              Positioned(
                top: 35.0,
                left: 12.0,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 20.0,
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ])
          : Stack(
              children: <Widget>[
                _buildCameraPreview(),
                Positioned(
                  top: 35.0,
                  left: 12.0,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 20.0,
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 35.0,
                  right: 12.0,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 20.0,
                    child: IconButton(
                      icon: Icon(
                        Icons.camera_front,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        _onCameraSwitch();
                      },
                    ),
                  ),
                ),
                widget.type == 'video'
                    ? Positioned(
                        left: 0,
                        right: 0,
                        top: 32.0,
                        child: VideoTimer(
                          key: _timerKey,
                        ),
                      )
                    : Container()
              ],
            ),
      bottomNavigationBar:
          _controller == null || !_controller.value.isInitialized
              ? Container()
              : _buildBottomNavigationBar(),
    );
  }

  Widget _buildCameraPreview() {
    // final size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(top: 25, bottom: 110),
      child: CameraPreview(_controller),
    );
    // return ClipRect(
    //   child: Container(
    //     child: Transform.scale(
    //       scale: _controller.value.aspectRatio / size.aspectRatio,
    //       child: Center(
    //         child: AspectRatio(
    //           aspectRatio: _controller.value.aspectRatio,
    //           child: CameraPreview(_controller),
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      color: Colors.transparent,
      height: 105.0,
      width: double.infinity,
      child: Center(
        child: widget.type == 'video'
            ? CircleAvatar(
                backgroundColor: Colors.white,
                radius: 28.0,
                child: IconButton(
                  icon: Icon(
                    (_isRecording) ? Icons.stop : Icons.videocam,
                    size: 28.0,
                    color: (_isRecording) ? Colors.red : Colors.black,
                  ),
                  onPressed: () {
                    if (_isRecording) {
                      stopVideoRecording();
                    } else {
                      startVideoRecording();
                    }
                  },
                ),
              )
            : CircleAvatar(
                backgroundColor: Colors.white,
                radius: 28.0,
                child: IconButton(
                  icon: Icon(
                    Icons.camera_alt,
                    size: 28.0,
                  ),
                  color: Colors.black,
                  onPressed: () {
                    _captureImage();
                  },
                ),
              ),
      ),
    );
  }

  Future<void> _onCameraSwitch() async {
    final CameraDescription cameraDescription =
        (_controller.description == _cameras[0]) ? _cameras[1] : _cameras[0];
    if (_controller != null) {
      await _controller.dispose();
    }
    _controller = CameraController(cameraDescription, ResolutionPreset.medium);
    _controller.addListener(() {
      if (mounted) setState(() {});
      if (_controller.value.hasError) {
        showInSnackBar('Camera error ${_controller.value.errorDescription}');
      }
    });

    try {
      await _controller.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  void _captureImage() async {
    print('_captureImage');
    if (_controller.value.isInitialized && !_controller.value.isTakingPicture) {
      SystemSound.play(SystemSoundType.click);
      // final Directory extDir = await getApplicationDocumentsDirectory();
      // final String dirPath = '${extDir.path}/media';
      // await Directory(dirPath).create(recursive: true);
      var dir = await globals.getDir();
      print(dir);
      final String filePath = '$dir/${_timestamp()}.jpeg';
      print('path: $filePath');
      await _controller.takePicture(filePath).then(
            (value) => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(imagePath: filePath),
              ),
            ),
          );
      setState(() {});
    }
  }

  Future<String> startVideoRecording() async {
    print('startVideoRecording');
    if (!_controller.value.isInitialized) {
      return null;
    }
    setState(() {
      _isRecording = true;
    });
    _timerKey.currentState.startTimer();

    // final Directory extDir = await getApplicationDocumentsDirectory();
    // final String dirPath = '${extDir.path}/media';
    // await Directory(dirPath).create(recursive: true);
    var dir = await globals.getDir();
    final String filePath = '$dir/${_timestamp()}.mp4';

    if (_controller.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return null;
    }

    try {
      videoPath = filePath;
      await _controller.startVideoRecording(filePath);
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    return filePath;
  }

  Future<void> stopVideoRecording() async {
    if (!_controller.value.isRecordingVideo) {
      return null;
    }
    _timerKey.currentState.stopTimer();
    setState(() {
      _isRecording = false;
    });

    try {
      await _controller.stopVideoRecording().then(
            (value) => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VideoPreview(videoPath: videoPath),
              ),
            ),
          );
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
  }

  String _timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  void _showCameraException(CameraException e) {
    logError(e.code, e.description);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }

  void showInSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  void logError(String code, String message) =>
      print('Error: $code\nError Message: $message');

  @override
  bool get wantKeepAlive => true;
}
