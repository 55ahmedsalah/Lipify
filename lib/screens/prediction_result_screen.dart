import 'package:flutter/material.dart';

class PredictionResultScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Predcition Result')),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Predicted text is', style: TextStyle(fontSize: 30.0)),
              SizedBox(height: 10.0),
              Text('I am feeling good', style: TextStyle(fontSize: 30.0))
            ],
          ),
        ),
      ),
    );
  }
}
