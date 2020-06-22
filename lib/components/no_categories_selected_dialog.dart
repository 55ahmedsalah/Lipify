import 'package:flutter/material.dart';

class NoCategoriesSelectedDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('No Categories Selected'),
      content: Text('Please select at least a single category'),
      actions: <Widget>[
        FlatButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
