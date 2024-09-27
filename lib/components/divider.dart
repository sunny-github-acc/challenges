import 'package:challenges/utils/colors.dart';
import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: colorMap['black']!.withOpacity(0.5),
    );
  }
}
