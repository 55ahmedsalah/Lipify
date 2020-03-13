import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:lipify/screens/sentence_structure_screen.dart';

const uploadVideoURL = 'http://192.168.1.200:3000/upload';
const getPredictedTextURL = 'http://192.168.1.200:3000/text';

class PredictionResultScreen extends StatefulWidget {
  final List<String> videoPaths;
  PredictionResultScreen(this.videoPaths);

  @override
  _PredictionResultScreenState createState() => _PredictionResultScreenState();
}

class _PredictionResultScreenState extends State<PredictionResultScreen> {
  bool _gettingData = true;
  String _predictedText = 'please lay by blue';

  Widget _loadingSpinKit = SpinKitDoubleBounce(
    color: Colors.white,
    size: 100.0,
  );

  void sendVideos(String filename, String url) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath('video', filename));
    try {
      // Adjust request timeout
      http.StreamedResponse response =
          await request.send().timeout(Duration(minutes: 2));
      if (response.statusCode == 200) {
        print('Success');
      } else {
        print(
            'Request failed with status: ${response.reasonPhrase} ${response.statusCode}.');
        setState(() {
          _loadingSpinKit =
              Text('Error! Check your internet connection and try again');
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        _loadingSpinKit =
            Text('Error! Check your internet connection and try again');
      });
    }
  }

  void getPredictedText(String url) async {
    try {
      http.Response response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          _predictedText = convert.jsonDecode(response.body);
          _gettingData = false;
        });
      } else {
        print(
            'Request failed with status: ${response.reasonPhrase} ${response.statusCode}.');
        setState(() {
          _loadingSpinKit =
              Text('Error! Check your internet connection and try again');
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        _loadingSpinKit =
            Text('Error! Check your internet connection and try again');
      });
    }
  }

  @override
  void initState() {
    super.initState();
    for (String video in widget.videoPaths) {
      sendVideos(video, uploadVideoURL);
    }
    getPredictedText(getPredictedTextURL);
    // setState(() {});
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
            child: _gettingData == true
                ? _loadingSpinKit
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Flexible(
                        child: Image.asset(
                          'images/logo.png',
                          width: 200.0,
                        ),
                      ),
                      Text('Predicted text is',
                          style: TextStyle(fontSize: 30.0)),
                      SizedBox(height: 10.0),
                      Text(
                        '$_predictedText',
                        style: TextStyle(fontSize: 30.0),
                      ),
                      SizedBox(height: 15.0),
                      RaisedButton.icon(
                        icon: Icon(Icons.sync),
                        label: Text('New Sentence'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SentenceStructureScreen(),
                            ),
                          );
                        },
                      )
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
