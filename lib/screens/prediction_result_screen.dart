import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lipify/screens/sentence_structure_screen.dart';

const url = 'http://192.168.1.200:3000/upload';

class PredictionResultScreen extends StatefulWidget {
  final List<String> videoPaths;
  PredictionResultScreen(this.videoPaths);

  @override
  _PredictionResultScreenState createState() => _PredictionResultScreenState();
}

class _PredictionResultScreenState extends State<PredictionResultScreen> {
  void sendVideos(String filename, String url) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath('video', filename));
    var res = await request.send();
  }

  @override
  void initState() {
    super.initState();
    for (String video in widget.videoPaths) {
      sendVideos(video, url);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text('Prediction Result')),
      body: WillPopScope(
        onWillPop: () {
          return new Future.value(false);
        },
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  child: Image.asset(
                    'images/logo.png',
                    width: 200.0,
                  ),
                ),
                Text('Predicted text is', style: TextStyle(fontSize: 30.0)),
                SizedBox(height: 10.0),
                Text(
                  '${widget.videoPaths.toString()}',
                  style: TextStyle(fontSize: 30.0),
                ),
                RaisedButton.icon(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SentenceStructureScreen(),
                        ));
                  },
                  icon: Icon(Icons.settings_backup_restore),
                  label: Text('New Sentence'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
