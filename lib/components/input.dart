import 'package:challenges/components/column.dart';
import 'package:challenges/utils/colors.dart';
import 'package:flutter/material.dart';

import 'package:challenges/components/text.dart';
import 'package:flutter/services.dart';

class CustomInput extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String? title;
  final String? labelText;
  final String? hintText;
  final bool isAutocorrect;
  final bool isDisabled;
  final bool isObscureText;
  final bool isSuggestions;
  final bool isTall;
  final int? limit;
  final void Function(String)? onChanged;

  const CustomInput({
    super.key,
    required this.controller,
    this.title,
    this.labelText,
    this.hintText,
    this.isAutocorrect = false,
    this.isDisabled = false,
    this.isObscureText = false,
    this.isSuggestions = true,
    this.isTall = false,
    this.keyboardType = TextInputType.text,
    this.limit,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CustomColumn(
      spacing: SpacingType.small,
      children: [
        if (title != null) CustomText(text: title!),
        SizedBox(
          height: isTall ? 150 : null,
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText: labelText,
              hintText: hintText,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: isDisabled ? colorMap['red']! : colorMap['blue']!,
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
            inputFormatters: limit != null
                ? [LengthLimitingTextInputFormatter(limit)]
                : null,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
