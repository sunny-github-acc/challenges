import 'package:challenges/components/text.dart';
import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget {
  final List<String>? titles;
  final List<dynamic> values;
  final Function(dynamic) onChanged;
  final dynamic value;
  final String? hint;

  const CustomDropdown({
    Key? key,
    required this.values,
    this.titles,
    required this.value,
    required this.onChanged,
    this.hint,
  }) : super(key: key);

  @override
  CustomDropdownState createState() => CustomDropdownState();
}

class CustomDropdownState extends State<CustomDropdown> {
  late dynamic _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<dynamic>(
      value: _selectedValue,
      hint: widget.hint != null ? CustomText(text: widget.hint!) : null,
      items: widget.values.map<DropdownMenuItem<dynamic>>((value) {
        int index = widget.values.indexOf(value);
        return DropdownMenuItem<dynamic>(
          value: value,
          child: CustomText(text: widget.titles?[index] ?? value),
        );
      }).toList(),
      onChanged: (dynamic newValue) {
        setState(() {
          _selectedValue = newValue!;
        });

        widget.onChanged(newValue!);
      },
    );
  }
}
