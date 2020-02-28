import 'package:camera/camera.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';

class LipifyCameraController {
  static Future<CameraDescription> getCamera(int index) async {
    // Obtain a list of the available cameras on the device.
    var cameras = await availableCameras();

    // Get a specific camera from the list of available cameras.
    return cameras[index];
  }

  static Future<String> capturePicture(Future<void> initializeControllerFuture,
      CameraController controller) async {
    // Ensure that the camera is initialized.
    await initializeControllerFuture;

    // Construct the path where the image should be saved using the
    // pattern package.
    final path = join(
      // Store the picture in the temp directory.
      // Find the temp directory using the `path_provider` plugin.
      (await getApplicationSupportDirectory()).path,
      '${DateTime.now()}-lipify.png',
    );

    /*
    join(
      // Store the picture in the temp directory.
      // Find the temp directory using the `path_provider` plugin.
      (await getTemporaryDirectory()).path,
      '${DateTime.now()}-lipify.png',
    );
     */

    // Attempt to take a picture and log where it's been saved.
    await controller.takePicture(path);
    print(path);
    return path;
  }

  static Future<String> captureVideo(Future<void> initializeControllerFuture,
      CameraController controller) async {
    // Ensure that the camera is initialized.
    await initializeControllerFuture;

    // Construct the path where the image should be saved using the
    // pattern package.
    final path = join(
      // Store the picture in the temp directory.
      // Find the temp directory using the `path_provider` plugin.
      (await getExternalStorageDirectory()).path,
      '${DateTime.now()}-lipify.mp4',
    );

    /*
    join(
      // Store the picture in the temp directory.
      // Find the temp directory using the `path_provider` plugin.
      (await getTemporaryDirectory()).path,
      '${DateTime.now()}-lipify.png',
    );
     */

    // Attempt to take a picture and log where it's been saved.
    await controller.startVideoRecording(path);
    Future.delayed(Duration(seconds: 3));
    await controller.stopVideoRecording();
    print(path);
    return path;
  }
}
