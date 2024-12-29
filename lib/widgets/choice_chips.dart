import 'package:flutter/material.dart';
class ChoiceChipsScreen extends StatefulWidget {
  final List? chipName;
  const ChoiceChipsScreen({Key? key, this.chipName}) : super(key: key);

  @override
  ChoiceChipsScreenState createState() => ChoiceChipsScreenState();
}

class ChoiceChipsScreenState extends State<ChoiceChipsScreen> {
  String _isSelected = "";

  _buildChoiceList() {
    List<Widget> choices = [];
    for (var item in widget.chipName!) {
      choices.add(Container(
        child: ChoiceChip(
          label: Text(item),
          labelStyle: const TextStyle(color: Colors.white),
          selectedColor: Colors.pinkAccent,
          backgroundColor: Colors.deepPurpleAccent,
          selected: _isSelected == item,
          onSelected: (selected) {
            setState(() {
              _isSelected = item;
            });
          },
        ),
      ));
    }
    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 5.0,
      runSpacing: 3.0,
      children: _buildChoiceList(),
    );
  }
}