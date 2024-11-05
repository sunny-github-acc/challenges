import 'package:challenges/components/text.dart';
import 'package:flutter/material.dart';
import 'package:challenges/utils/colors.dart';

class CustomDivider extends StatelessWidget {
  final String? text;

  const CustomDivider({
    super.key,
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: colorMap['black']!.withOpacity(0.5),
            thickness: 1.0,
          ),
        ),
        if (text != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: CustomText(
              text: text!,
              style: TextStyle(
                color: colorMap['black']!.withOpacity(0.7),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        Expanded(
          child: Divider(
            color: colorMap['black']!.withOpacity(0.5),
            thickness: 1.0,
          ),
        ),
      ],
    );
  }
}
