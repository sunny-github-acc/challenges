import 'package:flutter/material.dart';

class TextCustom extends StatelessWidget {
  final String text;
  final TextAlign textAlign;
  final FontWeight fontWeight;

  const TextCustom({
    super.key,
    required this.text,
    this.textAlign = TextAlign.start,
    this.fontWeight = FontWeight.normal,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        fontWeight: fontWeight,
      ),
    );
  }
}
