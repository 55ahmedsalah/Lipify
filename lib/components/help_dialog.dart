import 'package:flutter/material.dart';

class HelpDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: <Widget>[
          Icon(Icons.help_outline),
          Text(' About this page'),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          // mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
                'Choose your sentence structure by clicking in order the category of each word.\n\n'),
            Text('Command category words: \n • bin • lay • place • set\n'),
            Text('Color category words: \n • blue • green • red\n • white\n'),
            Text('Preposition category words: \n • at • by • in • with\n'),
            Text('Letter category words: \n • A to Z\n'),
            Text('Digit category words: \n • 0 to 9\n'),
            Text('Adverb category words: \n • again • now • please • soon\n'),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('OK'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
