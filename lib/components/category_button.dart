import 'package:flutter/material.dart';

class CategoryButton extends StatefulWidget {
  final String category;
  final List<Chip> sentenceStructure;
  CategoryButton(this.category, this.sentenceStructure);

  @override
  _CategoryButtonState createState() => _CategoryButtonState();
}

class _CategoryButtonState extends State<CategoryButton> {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: () {
        super.setState(
          () => widget.sentenceStructure.add(
            Chip(
              deleteIcon: Icon(Icons.close),
              deleteButtonTooltipMessage: 'Cancel',
              deleteIconColor: Colors.red,
              label: Text(widget.category),
              onDeleted: () => setState(() {
                widget.sentenceStructure.removeWhere((Chip category) {
                  print(category.label);
                  return category.label == Text(widget.category);
                });
                print(widget.sentenceStructure);
              }),
            ),
          ),
        );
        print(widget.sentenceStructure);
      },
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
