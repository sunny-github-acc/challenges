import 'package:flutter/material.dart';

class TextCustom extends StatelessWidget {
  final String text;
  final TextAlign textAlign;
  final FontWeight fontWeight;
  final bool fullWidth;

  const TextCustom({
    Key? key,
    required this.text,
    this.textAlign = TextAlign.start,
    this.fontWeight = FontWeight.normal,
    this.fullWidth = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      child: Text(
        text,
        textAlign: textAlign,
        style: TextStyle(
          fontSize: 20,
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}
