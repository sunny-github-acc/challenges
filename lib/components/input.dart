import 'package:challenges/components/column.dart';
import 'package:flutter/material.dart';

import 'package:challenges/components/text.dart';

class CustomInput extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String hintText;
  final String labelText;
  final String title;
  final bool isAutocorrect;
  final bool isDisabled;
  final bool isObscureText;
  final bool isSuggestions;
  final bool isTall;

  const CustomInput({
    super.key,
    required this.controller,
    required this.hintText,
    required this.labelText,
    this.isAutocorrect = false,
    this.isDisabled = false,
    this.isObscureText = false,
    this.isSuggestions = true,
    this.isTall = false,
    this.keyboardType = TextInputType.text,
    this.title = '',
  });

  @override
  Widget build(BuildContext context) {
    return CustomColumn(children: [
      if (title != '') TextCustom(text: title),
      SizedBox(
        height: isTall ? 150 : null,
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: labelText,
            hintText: hintText,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: isDisabled ? Colors.orangeAccent : Colors.black26,
                width: 1.0,
              ),
            ),
            alignLabelWithHint: true,
          ),
          maxLines: isTall ? 10 : 1,
          keyboardType: keyboardType,
          obscureText: isObscureText,
          autocorrect: isAutocorrect,
          enableSuggestions: isObscureText ? false : isSuggestions,
        ),
      )
    ]);
  }
}
