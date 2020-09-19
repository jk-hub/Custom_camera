import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:own_camera/camera_widget/camera_screen.dart';

List<CameraDescription> cameras;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Obtain a list of the available cameras on the device.
  cameras = await availableCameras();
  final firstCamera = cameras.first;
  runApp(
    MyApp(firstCamera: firstCamera),
  );
}

class MyApp extends StatelessWidget {
  final CameraDescription firstCamera;
  MyApp({this.firstCamera});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: CameraClass(firstCamera),
    );
  }
}

class CameraClass extends StatefulWidget {
  final cameras;
  CameraClass(this.cameras);

  @override
  _CameraClassState createState() => _CameraClassState();
}

class _CameraClassState extends State<CameraClass> {
  var image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('camera personal picker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: RaisedButton.icon(
              onPressed: () async {
                image = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CameraScreen('video'),
                  ),
                );
                print("imagePath ---------- $image");
              },
              icon: Icon(Icons.camera),
              label: Text('Video'),
            ),
          ),
          Container(
            child: RaisedButton.icon(
              onPressed: () async {
                image = await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CameraScreen('camera'),
                ));
                print("imagePath ---------- $image");
              },
              icon: Icon(Icons.camera),
              label: Text('camera'),
            ),
          ),
        ],
      ),
    );
  }
}
