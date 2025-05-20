import 'package:challenges/utils/colors.dart';
import 'package:flutter/material.dart';

class CustomSwitch extends StatelessWidget {
  final bool value;
  final Function? onChanged;

  const CustomSwitch({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 40,
        child: Switch(
          value: value,
          onChanged: (value) => onChanged != null ? onChanged!(value) : null,
          activeColor: colorMap['blue'],
        ));
  }
}
