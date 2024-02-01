import 'package:flutter/material.dart';

class SwitchCustom extends StatelessWidget {
  final bool value;
  final Function onChanged;

  const SwitchCustom({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: value,
      onChanged: (value) => onChanged(value),
      activeColor: Colors.green, // Set the color when the switch is ON
    );
  }
}
