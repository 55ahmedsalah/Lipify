import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lipify/screens/sentence_structure_screen.dart';
import 'package:lipify/styles.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text('Lipify')),
      body: SafeArea(
        child: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Welcome to Lipify',
                  style: kHomeScreenTextStyle,
                  textAlign: TextAlign.center,
                ),
                Image.asset(
                  'images/logo.png',
                  width: 200.0,
                ),
                Text(
                  'Your Lip Reading Assistant',
                  style: kHomeScreenTextStyle,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 4.0,
        icon: Icon(Icons.record_voice_over),
        label: Text('Sentence Structure'),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SentenceStructureScreen(),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
