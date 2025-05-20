import 'package:challenges/utils/colors.dart';
import 'package:flutter/material.dart';

class CustomCircularProgressIndicator extends StatelessWidget {
  final double? strokeWidth;
  final double? scale;

  const CustomCircularProgressIndicator({
    Key? key,
    this.strokeWidth = 4,
    this.scale = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(colorMap['blue']!),
        semanticsLabel: 'Circular progress indicator',
        strokeWidth: strokeWidth!,
      ),
    );
  }
}
