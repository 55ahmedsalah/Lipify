import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
// import 'package:lipify/screens/prediction_result_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() {
    return _CameraScreenState();
  }
}

List<CameraDescription> cameras = [];
CameraController controller;
VideoPlayerController videoController;

void logError(String code, String message) =>
    print('Error: $code\nError Message: $message');

void getCameras() async {
  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    logError(e.code, e.description);
  }
  if (cameras[1] != null) {
    controller = CameraController(
      cameras[1],
      ResolutionPreset.low,
      enableAudio: false,
    );
  }
}

void disposeControllers() async {
  await controller?.dispose();
  await videoController?.dispose();
}

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver {
  String videoPath;
  VoidCallback videoPlayerListener;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    setState(() {
      getCameras();
      if (controller != null) {
        controller.initialize().then((_) {
          if (!mounted) return;
        });
      }
    });
    // onNewCameraSelected(cameras[0]);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    disposeControllers();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    if (controller == null || !controller.value.isInitialized) return;

    if (state == AppLifecycleState.inactive) {
      if (controller.value.isRecordingVideo) {
        onVideoRecordStop();

        // final dir = Directory(dirPath);
        // dir.deleteSync(recursive: true);
      }
      disposeControllers();
    } else if (state == AppLifecycleState.resumed) {
      if (controller != null) onNewCameraSelected(controller.description);
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                child: Padding(
                  padding: EdgeInsets.all(1.0),
                  child: Center(
                    child: _cameraPreviewWidget(),
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(
                    color:
                        controller != null && controller.value.isRecordingVideo
                            ? Colors.redAccent
                            : Colors.black,
                    width: 2.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: controller != null &&
                controller.value.isInitialized &&
                !controller.value.isRecordingVideo
            ? Icon(
                Icons.camera,
                size: 35.0,
              )
            : Icon(
                Icons.close,
                size: 35.0,
              ),
        onPressed: controller != null &&
                controller.value.isInitialized &&
                !controller.value.isRecordingVideo
            ? onVideoRecordButtonPressed
            : null,
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 4.0,
        child: Container(
          height: 100.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.switch_camera),
                onPressed: controller != null &&
                        controller.value.isRecordingVideo
                    ? null
                    : () {
                        onNewCameraSelected(controller.description == cameras[0]
                            ? cameras[1]
                            : cameras[0]);
                      },
              ),
              _thumbnailWidget(),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  /// Display the preview from the camera (or a message if the preview is not available).
  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      return Text(
        'Tap a camera',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
        ),
      );
    } else {
      return AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: CameraPreview(controller),
      );
    }
  }

  /// Display the thumbnail of the captured image or video.
  Widget _thumbnailWidget() {
    return Expanded(
      child: Align(
        alignment: Alignment.bottomRight,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            videoController == null
                ? Container()
                : SizedBox(
                    child: Container(
                      child: Center(
                        child: AspectRatio(
                            aspectRatio: videoController.value.size != null
                                ? videoController.value.aspectRatio
                                : 1.0,
                            child: VideoPlayer(videoController)),
                      ),
                      decoration:
                          BoxDecoration(border: Border.all(color: Colors.pink)),
                    ),
                    width: 64.0,
                    height: 64.0,
                  ),
          ],
        ),
      ),
    );
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  void showInSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }
    controller = CameraController(
      cameraDescription,
      ResolutionPreset.low,
      enableAudio: false,
    );

    // If the controller is updated then update the UI.
    controller.addListener(() {
      if (mounted) setState(() {});
      if (controller.value.hasError) {
        showInSnackBar('Camera error ${controller.value.errorDescription}');
      }
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  void onVideoRecordButtonPressed() {
    startVideoRecording().then((String filePath) {
      if (mounted) setState(() {});
      if (filePath != null) {
        // showInSnackBar('Saving video to $filePath');
        Future.delayed(Duration(seconds: 3), () {
          if (controller != null &&
              controller.value.isInitialized &&
              controller.value.isRecordingVideo) onVideoRecordStop();
        });
      }
    });
  }

  Future<String> startVideoRecording() async {
    if (!controller.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }

    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Movies/flutter_test';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.mp4';

    if (controller.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return null;
    }

    try {
      videoPath = filePath;
      await controller.startVideoRecording(filePath);
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    return filePath;
  }

  void onVideoRecordStop() {
    stopVideoRecording().then((_) {
      if (mounted) setState(() {});
      // showInSnackBar('Video recorded to: $videoPath');
    });
  }

  Future<void> stopVideoRecording() async {
    if (!controller.value.isRecordingVideo) {
      return null;
    }

    try {
      await controller.stopVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }

    await _startVideoPlayer();
  }

  Future<void> _startVideoPlayer() async {
    if (videoPath == null || videoPath == '') return;
    final VideoPlayerController vcontroller =
        VideoPlayerController.file(File(videoPath));
    videoPlayerListener = () {
      if (videoController != null && videoController.value.size != null) {
        // Refreshing the state to update video player with the correct ratio.
        if (mounted) setState(() {});
        videoController.removeListener(videoPlayerListener);
      }
    };
    vcontroller.addListener(videoPlayerListener);
    await vcontroller.setLooping(true);
    await vcontroller.initialize();
    // await videoController?.dispose();
    if (mounted) {
      setState(() {
        videoController = vcontroller;
      });
    }
    await vcontroller.play();
  }

  void deleteVideo(String videoPath) async {}

  void _showCameraException(CameraException e) {
    logError(e.code, e.description);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }
}
