import 'package:flutter/material.dart';
import 'package:lipify/controllers/lipify_camera_controller.dart';

import 'package:lipify/screens/display_picture_screen.dart';
import 'package:lipify/screens/prediction_result_screen.dart';

import 'package:camera/camera.dart';

// A screen that allows users to take a picture using a given camera.
class CameraScreen extends StatefulWidget {
  @override
  CameraScreenState createState() => CameraScreenState();
}

class CameraScreenState extends State<CameraScreen> {
  CameraDescription camera;
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  int cameraIndex = 0;

  void initializeCamera(int cameraIndex) async {
    // To display the current output from the Camera,
    // Get camera
    camera = await LipifyCameraController.getCamera(cameraIndex);

    setState(() {
      // create a CameraController.
      _controller = CameraController(
        // Get a specific camera from the list of available cameras.
        camera,
        // Define the resolution to use.
        ResolutionPreset.low,
        // Disable audio.
        enableAudio: false,
      );

      // Next, initialize the controller. This returns a Future.
      _initializeControllerFuture = _controller.initialize();

      cameraIndex = cameraIndex == 0 ? 1 : 0;
    });
  }

  void takePicture() async {
    // Take the Picture in a try / catch block. If anything goes wrong,
    // catch the error.
    try {
      String path = await LipifyCameraController.capturePicture(
          _initializeControllerFuture, _controller);
      print(path);
      /*
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              DisplayPictureScreen(imagePath: path),
        ),
      );
      */
    } catch (e) {
      // If an error occurs, log the error to the console.
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    initializeCamera(cameraIndex);
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner
      // until the controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.camera,
          size: 35.0,
        ),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PredictionResultScreen(),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 4.0,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            IconButton(
              icon: Icon(Icons.camera_alt),
              onPressed: () async {
                initializeCamera(cameraIndex);
              },
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
