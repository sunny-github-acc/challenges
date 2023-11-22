import 'package:challenges/components/column.dart';
import 'package:flutter/material.dart';

import 'package:challenges/components/text.dart';

class CustomInput extends StatelessWidget {
  final String title;
  final String labelText;
  final String hintText;
  final TextEditingController controller;
  final bool obscureText;
  final bool disabled;
  final bool isTall;
  final double padding;
  final bool isInputTypeText;

  const CustomInput({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.controller,
    this.title = '',
    this.obscureText = false,
    this.isTall = false,
    this.disabled = false,
    this.padding = 8.0,
    this.isInputTypeText = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: CustomColumn(children: [
        TextCustom(text: title),
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
          ),
        )
      ]),
    );
  }
}
