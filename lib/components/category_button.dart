import 'package:flutter/material.dart';

class CategoryButton extends StatefulWidget {
  final String category;
  final List<Text> sentenceStructure;
  CategoryButton(this.category, this.sentenceStructure);

  @override
  _CategoryButtonState createState() => _CategoryButtonState();
}

class _CategoryButtonState extends State<CategoryButton> {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () => setState(
        () => widget.sentenceStructure.add(
          Text(widget.category),
        ),
      ),
      child: Text(widget.category),
    );
  }
}

// _sentenceStructureChips.add(
//   Chip(
//     avatar: CircleAvatar(
//       backgroundColor: Colors.grey.shade800,
//       child: Text(category),
//     ),
//     label: Text(category),
//   ),
// );
