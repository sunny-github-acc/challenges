import 'package:flutter/material.dart';

class InputCustom extends StatelessWidget {
  final String labelText;
  final String hintText;
  final TextEditingController controller;
  final bool obscureText;
  final bool disabled;
  final double padding;

  const InputCustom({
    required this.labelText,
    required this.hintText,
    required this.controller,
    this.obscureText = false,
    this.disabled = false,
    this.padding = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return
      Padding(
        padding: EdgeInsets.all(padding),
        child: TextFormField(
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
          ),
          obscureText: obscureText,
        ),
      );
  }
}
