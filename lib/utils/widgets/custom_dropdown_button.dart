import 'package:flutter/material.dart';

class CustomDropdownButton extends StatelessWidget {
  final dropdownValue;
  final List items;
  final void Function(String?)? onChanged;
  const CustomDropdownButton({Key? key, required this.dropdownValue, required this.items, required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
        value: dropdownValue,
        icon: Icon(Icons.arrow_drop_down, color: Colors.purpleAccent),
        iconSize: 28,
        elevation: 16,
        underline: Container(height: 2.0, color: Colors.purpleAccent),
        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        items: items.map<DropdownMenuItem<String>>((value) => DropdownMenuItem<String>(child: Text(value), value: value)).toList(),
        onChanged: onChanged);
  }
}
