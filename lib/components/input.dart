import 'package:challenges/components/column.dart';
import 'package:flutter/material.dart';

import 'package:challenges/components/text.dart';

class CustomInput extends StatelessWidget {
  final String hintText;
  final String labelText;
  final String title;
  final TextEditingController controller;
  final bool disabled;
  final bool isInputTypeText;
  final bool isTall;
  final bool obscureText;
  final bool autocorrect;

  const CustomInput({
    super.key,
    required this.controller,
    required this.hintText,
    required this.labelText,
    this.disabled = false,
    this.isInputTypeText = true,
    this.isTall = false,
    this.obscureText = false,
    this.autocorrect = true,
    this.title = '',
  });

  @override
  Widget build(BuildContext context) {
    return CustomColumn(children: [
      if (title != '') TextCustom(text: title),
      SizedBox(
        height: isTall ? 150 : null,
        child: TextFormField(
          keyboardType:
              isInputTypeText ? TextInputType.text : TextInputType.number,
          controller: controller,
          decoration: InputDecoration(
            labelText: labelText,
            hintText: hintText,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: disabled ? Colors.orangeAccent : Colors.black26,
                width: 1.0,
              ),
            ),
            alignLabelWithHint: true,
          ),
          maxLines: isTall ? 10 : 1,
          obscureText: obscureText,
          autocorrect: autocorrect,
        ),
      )
    ]);
  }
}
