import 'package:flutter/material.dart';

import 'package:lipify/components/help_dialog.dart';
import 'package:lipify/components/no_categories_selected_dialog.dart';

import 'package:lipify/screens/camera_screen.dart';

class SentenceStructureScreen extends StatefulWidget {
  @override
  _SentenceStructureScreenState createState() =>
      _SentenceStructureScreenState();
}

class _SentenceStructureScreenState extends State<SentenceStructureScreen> {
  // Chips to be shown as user clicks on categories
  List<Chip> _sentenceStructureChips = [];

  // Chips to be shown on the Camera Screen
  List<Chip> _sentenceStructureCameraChips = [];

  // Is category pressed?
  // Used to make categories clickable once
  Map<String, bool> _pressed = {
    'Adverb': false,
    'Alphabet': false,
    'Colors': false,
    'Commands': false,
    'Numbers': false,
    'Prepositions': false,
  };

  // Show a help dialog when user clicks on the help button
  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (_) => HelpDialog(),
    );
  }

  // Remove category from chips array
  void _removeSelectedCategory(String category) {
    setState(() {
      _pressed[category] = false;
      _sentenceStructureCameraChips.removeWhere((Chip chip) {
        return chip.label.toString() == Text(category).toString();
      });
      _sentenceStructureChips.removeWhere((Chip chip) {
        return chip.label.toString() == Text(category).toString();
      });
    });
  }

  // Show an alert if the user clicks
  // on the 'Open Camera' button without selecting any category
  void _showCategoriesAlert() {
    showDialog(
      context: context,
      builder: (_) => NoCategoriesSelectedDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sentence Structure'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.help),
            onPressed: () {
              _showHelpDialog();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Image.asset(
                    'images/logo.png',
                    width: 150.0,
                  ),
                ),
              ),
              Text(
                'My sentence structure will be:',
                textScaleFactor: 1.7,
                style: TextStyle(fontWeight: FontWeight.w400),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _categoryButton('Adverb'),
                  _categoryButton('Alphabet'),
                ],
              ),
              SizedBox(height: 5.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _categoryButton('Colors'),
                  _categoryButton('Commands'),
                ],
              ),
              SizedBox(height: 5.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _categoryButton('Numbers'),
                  _categoryButton('Prepositions'),
                ],
              ),
              SizedBox(height: 5.0),
              Container(
                height: 70.0,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: _sentenceStructureChips,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: _sentenceStructureChips.length > 0 ? 4.0 : null,
        icon: Icon(Icons.videocam),
        label: Text('Open Camera'),
        onPressed: _sentenceStructureChips.length > 0
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CameraScreen(_sentenceStructureCameraChips),
                  ),
                );
              }
            : () => _showCategoriesAlert(),
        backgroundColor:
            _sentenceStructureChips.length > 0 ? null : Colors.grey[400],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  // Category button
  Widget _categoryButton(String category) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        child: RaisedButton(
          onPressed: _pressed[category]
              ? null
              : () {
                  setState(
                    () {
                      _sentenceStructureCameraChips
                          .add(Chip(label: Text(category)));
                      _sentenceStructureChips.add(
                        Chip(
                          deleteIcon: Icon(Icons.cancel),
                          deleteButtonTooltipMessage: 'Remove category',
                          deleteIconColor: Color(0xFFC7042C),
                          label: Text(category),
                          padding: EdgeInsets.all(3.0),
                          onDeleted: () {
                            _pressed[category] = false;
                            _sentenceStructureCameraChips
                                .removeWhere((Chip chip) {
                              return chip.label.toString() ==
                                  Text(category).toString();
                            });
                            _sentenceStructureChips.removeWhere((Chip chip) {
                              return chip.label.toString() ==
                                  Text(category).toString();
                            });
                            setState(() {});
                          },
                          elevation: 2.0,
                        ),
                      );
                      _pressed[category] = true;
                    },
                  );
                },
          child: Text(category),
          color: _pressed[category] ? Colors.grey : null,
        ),
      ),
    );
  }
}
