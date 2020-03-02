import 'package:camera/camera.dart';

class LipifyCameraController {
  static Future<CameraDescription> getCamera(int index) async {
    // Obtain a list of the available cameras on the device.
    var cameras = await availableCameras();

    // Get a specific camera from the list of available cameras.
    return cameras[index];
  }
}
