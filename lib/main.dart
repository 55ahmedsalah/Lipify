import 'package:flutter/material.dart';
import 'package:lipify/screens/home_screen.dart';

void main() {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();
  runApp(LipifyApp());
}

class LipifyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lipify',
      theme: ThemeData.dark(),
      home: HomeScreen(),
    );
  }
}
