import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class LipifyCameraPreview extends StatelessWidget {
  final CameraController controller;
  LipifyCameraPreview(this.controller);
  @override
  Widget build(BuildContext context) {
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
}
