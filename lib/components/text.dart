import 'package:flutter/material.dart';

enum FontSizeType {
  xlarge,
  large,
  medium,
  none,
}

Map<FontSizeType, double> fontSizeMap = {
  FontSizeType.xlarge: 28,
  FontSizeType.large: 24,
  FontSizeType.medium: 20,
  FontSizeType.none: 20,
};

class CustomText extends StatelessWidget {
  final String text;
  final TextAlign textAlign;
  final FontSizeType? fontSize;
  final FontWeight fontWeight;
  final bool fullWidth;
  final TextStyle? style;

  const CustomText({
    Key? key,
    required this.text,
    this.textAlign = TextAlign.start,
    this.fontWeight = FontWeight.normal,
    this.fullWidth = false,
    this.fontSize = FontSizeType.medium,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      child: Text(
        text,
        textAlign: textAlign,
        style: style ??
            TextStyle(
              fontSize: fontSizeMap[fontSize],
              fontWeight: fontWeight,
            ),
      ),
    );
  }
}
