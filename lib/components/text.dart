import 'package:flutter/material.dart';

class TextCustom extends StatelessWidget {
  final String text;
  final TextAlign textAlign;

  const TextCustom({
    super.key,
    required this.text,
    this.textAlign = TextAlign.start, // Default to left-aligned text
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
    );
  }
}
