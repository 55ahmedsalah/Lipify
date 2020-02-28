import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:lipify/components/category_button.dart';
import 'package:lipify/components/help_dialog.dart';
import 'package:lipify/controllers/lipify_camera_controller.dart';
import 'package:lipify/screens/camera_screen.dart';

class SentenceStructureScreen extends StatefulWidget {
  @override
  _SentenceStructureScreenState createState() =>
      _SentenceStructureScreenState();
}

class _SentenceStructureScreenState extends State<SentenceStructureScreen> {
  @override
  Widget build(BuildContext context) {
    // List<Chip> _sentenceStructureChips = [];
    List<Text> _sentenceStructure = [];

    void _showAboutAlertDialog() {
      showDialog(
        context: context,
        builder: (_) => HelpDialog(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Sentence Structure'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.help),
            onPressed: () {
              _showAboutAlertDialog();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'My sentence\'s structure will be:',
                style: TextStyle(fontSize: 30.0),
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  CategoryButton('Command', _sentenceStructure),
                  CategoryButton('Color', _sentenceStructure),
                  CategoryButton('Preposition', _sentenceStructure),
                ],
              ),
              SizedBox(height: 5.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  CategoryButton('Letter', _sentenceStructure),
                  CategoryButton('Digit', _sentenceStructure),
                  CategoryButton('Adverb', _sentenceStructure),
                ],
              ),
              SizedBox(height: 5.0),
              Container(
                height: 100.0,
                child: Row(
                  children: _sentenceStructure.toList(),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 4.0,
        icon: const Icon(Icons.videocam),
        label: const Text('Open Camera'),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CameraScreen(),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
