import 'dart:io';

import 'package:flutter/material.dart';

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key key, this.imagePath}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Container(
            color: Colors.black,
            margin: EdgeInsets.only(top: 25),
            child: Center(
              child: Image.file(
                File(imagePath),
              ),
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
                        Navigator.pop(context, imagePath);
                      }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
