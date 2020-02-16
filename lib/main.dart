import 'package:flutter/material.dart';
import 'package:lipify/screens/home_screen.dart';

main() {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      home: HomeScreen(),
      // home: CameraScreen(camera: firstCamera),
    ),
  );
}
