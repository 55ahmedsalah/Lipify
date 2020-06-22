import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:lipify/main.dart';

class PredictionResultScreen extends StatefulWidget {
  final List<String> videoPaths;
  PredictionResultScreen(this.videoPaths);

  @override
  _PredictionResultScreenState createState() => _PredictionResultScreenState();
}

class _PredictionResultScreenState extends State<PredictionResultScreen> {
  bool _gettingData = true;
  String _predictedText = '';
  String _ipAddress = '';
  var _controller = TextEditingController();
  Widget _loadingSpinKit;

  Widget _errorWidget(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Error! Server maybe down or you don\'t have an internet connection',
          textAlign: TextAlign.center,
        ),
        RaisedButton.icon(
          icon: Icon(Icons.sync),
          label: Text('New Sentence'),
          onPressed: () {
            RestartWidget.restartApp(context);
          },
        ),
      ],
    );
  }

  Future<void> sendVideos(String filename, String url) async {
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath('video', filename));
    try {
      // Adjust request timeout
      http.StreamedResponse response =
          await request.send().timeout(Duration(seconds: 30));
      if (response.statusCode == 200) {
        print('Success');
      } else {
        print(
            'Request failed with status: ${response.reasonPhrase} ${response.statusCode}.');
        setState(() {
          _loadingSpinKit = _errorWidget(context);
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        _loadingSpinKit = _errorWidget(context);
      });
    }
  }

  Future<void> getPredictedText(String url) async {
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
          _loadingSpinKit = _errorWidget(context);
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        _loadingSpinKit = _errorWidget(context);
      });
    }
  }

  void applyIP() async {
    setState(() {
      _loadingSpinKit = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Analyzing your videos...'),
          SizedBox(height: 10.0),
          SpinKitDoubleBounce(
            color: Colors.white,
            size: 100.0,
          ),
        ],
      );
    });
    for (String video in widget.videoPaths) {
      await sendVideos(video, 'http://192.168.$_ipAddress:3000/upload');
    }
    await getPredictedText('http://192.168.$_ipAddress:3000/text');
  }

  @override
  void initState() {
    super.initState();
    _loadingSpinKit = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Enter last 2 groups of server address digits',
            ),
            autofocus: true,
            controller: _controller,
            onChanged: (value) => setState(() {
              _ipAddress = value;
              // enableSending = _ipAddress != '';
              print(_ipAddress);
              // print(enableSending);
            }),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(5.0),
          child: RawMaterialButton(
            constraints: BoxConstraints.tightFor(width: 45.0, height: 45.0),
            child: Icon(Icons.send),
            fillColor: Colors.lightBlueAccent,
            shape: CircleBorder(),
            onPressed: () {
              if (_ipAddress != "") applyIP();
            },
          ),
        ),
      ],
    );
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
                      Text(
                        'Predicted Text',
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        '$_predictedText',
                        style: TextStyle(fontSize: 30.0),
                      ),
                      SizedBox(height: 40.0),
                      RaisedButton.icon(
                        icon: Icon(Icons.sync),
                        label: Text('New Sentence'),
                        onPressed: () {
                          RestartWidget.restartApp(context);
                        },
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
