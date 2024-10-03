import 'package:challenges/components/text.dart';
import 'package:challenges/utils/colors.dart';
import 'package:flutter/material.dart';

class CustomCheckbox extends StatelessWidget {
  final bool isChecked;
  final String label;
  final ValueChanged<bool> onChanged;

  const CustomCheckbox({
    Key? key,
    required this.isChecked,
    required this.label,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged(!isChecked);
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Checkbox(
            value: isChecked,
            onChanged: (bool? value) {
              onChanged(value!);
            },
            activeColor: colorMap['blue'],
            checkColor: colorMap['white'],
          ),
          CustomText(
            text: label,
            fontSize: FontSizeType.medium,
          ),
        ],
      ),
    );
  }
}
