import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:lipify/screens/camera_screen.dart';

class SentenceStructureScreen extends StatefulWidget {
  @override
  _SentenceStructureScreenState createState() =>
      _SentenceStructureScreenState();
}

class _SentenceStructureScreenState extends State<SentenceStructureScreen> {
  Future<CameraDescription> getCamera() async {
    // Obtain a list of the available cameras on the device.
    var cameras = await availableCameras();

    // Get a specific camera from the list of available cameras.
    return cameras.first;
  }

  @override
  Widget build(BuildContext context) {
    List<Chip> _sentenceStructureChips = [];
    List<Text> _sentenceStructure = [];

    RaisedButton categoryButton(String category) {
      return RaisedButton(
        onPressed: () {
          setState(() {
            _sentenceStructure.add(Text(category));
            // _sentenceStructureChips.add(
            //   Chip(
            //     avatar: CircleAvatar(
            //       backgroundColor: Colors.grey.shade800,
            //       child: Text(category),
            //     ),
            //     label: Text(category),
            //   ),
            // );
          });
          print(_sentenceStructure.toString());
          print(_sentenceStructure.length);
        },
        child: Text(category),
      );
    }

    void _showAboutAlertDialog() {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: Text('About this page'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              RichText(
                text: TextSpan(
                  text:
                      'In this page the user chooses the order in which they will say their sentence.\n\n',
                  // style: const TextStyle(color: Colors.black87),
                  children: <TextSpan>[
                    TextSpan(
                        text:
                            'Command category words: \n • bin • lay • place • set\n\n'),
                    TextSpan(
                        text:
                            'Color category words: \n • blue • green • red\n • white\n\n'),
                    TextSpan(
                        text:
                            'Preposition category words: \n • at • by • in • with\n\n'),
                    TextSpan(text: 'Letter category words: \n • A to Z\n\n'),
                    TextSpan(text: 'Digit category words: \n • 0 to 9\n\n'),
                    TextSpan(
                        text:
                            'Adverb category words: \n • again • now • please • soon\n\n'),
                  ],
                ),
              ),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
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
                  categoryButton('Command'),
                  categoryButton('Color'),
                  categoryButton('Preposition'),
                ],
              ),
              SizedBox(height: 5.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  categoryButton('Letter'),
                  categoryButton('Digit'),
                  categoryButton('Adverb'),
                ],
              ),
              SizedBox(height: 5.0),
              Container(
                height: 100.0,
                child: Row(
                  children: _sentenceStructure,
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
        onPressed: () async {
          CameraDescription camera = await getCamera();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CameraScreen(
                camera: camera,
              ),
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
