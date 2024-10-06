import 'package:flutter/material.dart';

class CustomSpinner extends StatefulWidget {
  const CustomSpinner({super.key});

  @override
  State<CustomSpinner> createState() => _CustomSpinnerState();
}

class _CustomSpinnerState extends State<CustomSpinner> {
  String _selectedValue = 'Option 1';

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (String value) {
        setState(() {
          _selectedValue = value;
        });
      },
      itemBuilder: (BuildContext context) {
        return <String>['Option 1', 'Option 2', 'Option 3'].map((String value) {
          return PopupMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_selectedValue),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}
