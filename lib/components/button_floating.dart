import 'package:challenges/utils/colors.dart';
import 'package:flutter/material.dart';

class FloatingButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  final Alignment alignment;

  const FloatingButton({
    Key? key,
    required this.child,
    required this.onPressed,
    this.alignment = Alignment.bottomRight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color textColor = colorMap['white']!;
    Color borderColor = colorMap['blue']!;

    return Align(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FloatingActionButton(
          backgroundColor: textColor,
          foregroundColor: borderColor,
          onPressed: onPressed,
          child: child,
        ),
      ),
    );
  }
}
