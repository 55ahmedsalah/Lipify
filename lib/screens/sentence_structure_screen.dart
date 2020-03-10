import 'package:flutter/material.dart';
import 'package:lipify/components/help_dialog.dart';
import 'package:lipify/screens/camera_screen.dart';

class SentenceStructureScreen extends StatefulWidget {
  @override
  _SentenceStructureScreenState createState() =>
      _SentenceStructureScreenState();
}

class _SentenceStructureScreenState extends State<SentenceStructureScreen> {
  List<Chip> _sentenceStructureChips = [];
  List<Chip> _sentenceStructureCameraChips = [];
  Map<String, bool> _pressed = {
    'Command': false,
    'Color': false,
    'Preposition': false,
    'Letter': false,
    'Digit': false,
    'Adverb': false
  };

  void _showAboutAlertDialog() {
    showDialog(
      context: context,
      builder: (_) => HelpDialog(),
    );
  }

  void _showCategoriesAlert() {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Row(
                children: <Widget>[
                  //Icon(Icons.error),
                  Text('No Categories Selected'),
                ],
              ),
              content: Text('Please select at least a single category'),
              actions: <Widget>[
                FlatButton(
                  child: Text('OK'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {});
    return Scaffold(
      appBar: AppBar(
        title: Text('Sentence Structure'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.help),
            onPressed: () {
              _showAboutAlertDialog();
              print(_sentenceStructureChips);
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
                'My sentence\'s structure will be:',
                style: TextStyle(fontSize: 30.0),
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _raisedButton('Command'),
                  _raisedButton('Color'),
                  _raisedButton('Preposition'),
                ],
              ),
              SizedBox(height: 5.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _raisedButton('Letter'),
                  _raisedButton('Digit'),
                  _raisedButton('Adverb'),
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
            ? () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CameraScreen(_sentenceStructureCameraChips),
                  ),
                )
            : () => _showCategoriesAlert(),
        backgroundColor:
            _sentenceStructureChips.length > 0 ? null : Colors.grey[400],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _raisedButton(String category) {
    return RaisedButton(
      onPressed: _pressed[category]
          ? null
          : () => setState(
                () {
                  _sentenceStructureCameraChips
                      .add(Chip(label: Text(category)));
                  _sentenceStructureChips.add(
                    Chip(
                      deleteIcon: Icon(Icons.close),
                      deleteButtonTooltipMessage: 'Cancel',
                      deleteIconColor: Colors.red,
                      label: Text(category),
                      padding: EdgeInsets.all(3.0),
                      onDeleted: () {
                        _pressed[category] = false;
                        _sentenceStructureCameraChips.removeWhere((Chip chip) {
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
              ),
      child: Text(category),
    );
  }
}
