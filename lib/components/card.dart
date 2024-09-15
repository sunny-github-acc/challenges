import 'package:challenges/utils/colors.dart';
import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final Color? color;
  final double borderRadius;
  final EdgeInsets padding;
  final VoidCallback? onPressed;

  const CustomCard({
    super.key,
    required this.child,
    this.color,
    this.borderRadius = 8.0,
    this.padding = const EdgeInsets.all(16.0),
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (onPressed == null) {
      return Card(
        color: color ?? colorMap['white']!,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Padding(
          padding: padding,
          child: child,
        ),
      );
    }

    return GestureDetector(
      onTap: onPressed,
      child: Card(
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
