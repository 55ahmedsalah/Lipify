import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:lipify/controllers/lipify_camera_controller.dart';
import 'package:lipify/screens/prediction_result_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

class CameraScreen extends StatefulWidget {
  final List<Chip> sentenceStructureCameraChips;
  CameraScreen(this.sentenceStructureCameraChips);

  @override
  _CameraScreenState createState() {
    return _CameraScreenState();
  }
}

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // List<CameraDescription> _cameras = [];
  bool _videoRecordButtonPressed = false;
  CameraController _controller;
  CameraDescription _camera;
  Future<void> _initializeControllerFuture;
  int _videoIndex = 0;
  List<String> _videos = [];
  String _videoPath;
  VideoPlayerController _videoController;
  VoidCallback _videoPlayerListener;

  void _initializeCamera(int cameraIndex) async {
    // To display the current output from the Camera,
    // Get camera
    _camera = await LipifyCameraController.getCamera(cameraIndex);

    // setState(() {});
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      _camera,
      // Define the resolution to use.
      ResolutionPreset.low,
      // Disable audio.
      enableAudio: false,
    );

    // Next, initialize the controller. This returns a Future.
    if (_controller != null) {
      _initializeControllerFuture = _controller.initialize().then((_) {
        if (!mounted) return;
      });
    }

    try {
      await _initializeControllerFuture;
    } catch (e) {
      print(e);
    }
    setState(() {});
  }

  void logError(String code, String message) =>
      print('Error: $code\nError Message: $message');

  void _showInSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  void _showCameraException(CameraException e) {
    logError(e.code, e.description);
    _showInSnackBar('Error: ${e.code}\n${e.description}');
  }

  /*
  void _getCameras() async {
    try {
      _cameras = await availableCameras();
    } on CameraException catch (e) {
      logError(e.code, e.description);
    }
    if (_cameras[0] != null) {
      _controller = CameraController(
        _cameras[0],
        ResolutionPreset.medium,
        enableAudio: false,
      );
    }
  }
  */

  void _disposeControllers() async {
    await _controller?.dispose();
    await _videoController?.dispose();
  }

  // Video Capturing Functions
  void _onNewCameraSelected(CameraDescription cameraDescription) async {
    if (_controller != null) {
      await _controller.dispose();
    }
    _controller = CameraController(
      cameraDescription,
      ResolutionPreset.low,
      enableAudio: false,
    );

    // If the controller is updated then update the UI.
    _controller.addListener(() {
      if (mounted) setState(() {});
      if (_controller.value.hasError) {
        _showInSnackBar('Camera error ${_controller.value.errorDescription}');
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

  void _onVideoRecordButtonPressed(String category) {
    _startVideoRecording(category).then((String filePath) {
      if (filePath != null) {
        // File already exists or another camera exception is thrown
        _videos.add(filePath);
        Future.delayed(
          Duration(milliseconds: 1200),
          () {
            if (_controller != null &&
                _controller.value.isInitialized &&
                _controller.value.isRecordingVideo) _onVideoRecordStop();
          },
        );
      }
      if (mounted) setState(() {});
    });
  }

  Future<String> _startVideoRecording(String category) async {
    if (!_controller.value.isInitialized) {
      _showInSnackBar('Error: select a camera first.');
      return null;
    }

    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Movies/flutter_test';
    await Directory(dirPath).create(recursive: true);
    _videoIndex++;
    final String filePath = '$dirPath/${_videoIndex}_$category.mp4';

    if (_controller.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return null;
    }

    try {
      _videoPath = filePath;
      await _controller.startVideoRecording(filePath);
      return filePath;
    } on CameraException catch (e) {
      _videoIndex--;
      _deleteVideo(filePath);
      _showCameraException(e);
      return null;
    }
  }

  void _onVideoRecordStop() {
    _stopVideoRecording().then((_) {
      widget.sentenceStructureCameraChips.removeAt(0);
      if (widget.sentenceStructureCameraChips.length == 0) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PredictionResultScreen(_videos),
            ));
        return;
      }
      if (mounted) setState(() {});
    });
  }

  Future<void> _stopVideoRecording() async {
    if (!_controller.value.isRecordingVideo) {
      return null;
    }

    try {
      await _controller.stopVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
    await _startVideoPlayer();
  }

  Future<void> _startVideoPlayer() async {
    if (_videoPath == null || _videoPath == '') return;
    final VideoPlayerController vcontroller =
        VideoPlayerController.file(File(_videoPath));
    _videoPlayerListener = () {
      if (_videoController != null && _videoController.value.size != null) {
        // Refreshing the state to update video player with the correct ratio.
        if (mounted) setState(() {});
        _videoController.removeListener(_videoPlayerListener);
      }
    };
    vcontroller.addListener(_videoPlayerListener);
    await vcontroller.setLooping(true);
    await vcontroller.initialize();
    // await videoController?.dispose();
    if (mounted) {
      setState(() {
        _videoController = vcontroller;
      });
    }
    try {
      await vcontroller.play();
    } catch (e) {}
  }

  void _deleteVideosDirectory() async {
    try {
      final Directory extDir = await getApplicationDocumentsDirectory();
      final String dirPath = '${extDir.path}/Movies/flutter_test';
      await Directory(dirPath).delete(recursive: true);
    } catch (e) {
      print(e);
    }
  }

  void _deleteVideo(String videoPath) async {
    await File(videoPath).delete(recursive: false);
  }

  void _setActiveCategory() {
    print(widget.sentenceStructureCameraChips[0]);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera(1);
    _setActiveCategory();
    _deleteVideosDirectory();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _disposeControllers();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    if (_controller == null || !_controller.value.isInitialized) return;

    if (state == AppLifecycleState.inactive) {
      if (_controller.value.isRecordingVideo) {
        _onVideoRecordStop();

        // final dir = Directory(dirPath);
        // dir.deleteSync(recursive: true);
      }
      _disposeControllers();
    } else if (state == AppLifecycleState.resumed) {
      if (_controller != null) _onNewCameraSelected(_controller.description);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: WillPopScope(
        onWillPop: () => _videoRecordButtonPressed
            ? Future.value(false)
            : Future.value(true),
        child: SafeArea(
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
                      color: _controller != null &&
                              _controller.value.isRecordingVideo
                          ? Colors.redAccent[700]
                          : Colors.black,
                      width: 2.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: _controller != null &&
                _controller.value.isInitialized &&
                !_controller.value.isRecordingVideo
            ? Icon(
                Icons.camera,
                size: 35.0,
              )
            : null, // Icon(Icons.close, size: 35.0),
        onPressed: _controller != null &&
                _controller.value.isInitialized &&
                !_controller.value.isRecordingVideo
            ? () {
                _videoRecordButtonPressed = true;
                var category =
                    widget.sentenceStructureCameraChips[0].label as Text;
                _onVideoRecordButtonPressed(category.data);
              }
            : null,
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 4.0,
        child: Container(
          height: 150.0,
          child: Column(
            children: <Widget>[
              SizedBox(height: 30.0),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.0),
                  child: Row(
                    children: widget.sentenceStructureCameraChips,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  _thumbnailWidget(),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  /// Display the preview from the camera (or a message if the preview is not available).
  FutureBuilder<void> _cameraPreviewWidget() {
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // If the Future is complete, display the preview.
          return AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: CameraPreview(_controller),
          );
        } else {
          // Otherwise, display a loading indicator.
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  /// Display the thumbnail of the captured image or video.
  Widget _thumbnailWidget() {
    return Expanded(
      child: Align(
        alignment: Alignment.bottomRight,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _videoController == null
                ? Container()
                : SizedBox(
                    child: Container(
                      child: Center(
                        child: AspectRatio(
                            aspectRatio: _videoController.value.size != null
                                ? _videoController.value.aspectRatio
                                : 1.0,
                            child: VideoPlayer(_videoController)),
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
}
