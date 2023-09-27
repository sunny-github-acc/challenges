import 'package:flutter/material.dart';

enum ButtonType {
  primary,
  secondary,
  transparent,
}

enum ButtonSize {
  normal,
  small,
}

enum IconType {
  none,
  google,
}

class ButtonCustom extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final ButtonType type;
  final ButtonSize size;
  final IconType icon;

  const ButtonCustom({
    super.key,
    required this.onPressed,
    required this.text,
    this.type = ButtonType.primary,
    this.size = ButtonSize.normal,
    this.icon = IconType.none,
  });

  @override
  Widget build(BuildContext context) {
    double paddingVertical = 10;
    double paddingHorizontal = 20;
    Color buttonColor = Colors.green.shade300;
    Color textColor = Colors.white;
    Color borderColor = Colors.green.shade200;
    double fontSize = 30;
    FontWeight fontWeight = FontWeight.bold;
    String iconPath = '';

    if (type == ButtonType.secondary) {
      buttonColor = Colors.transparent;
      textColor = Colors.white;
      borderColor = Colors.green.shade200;
    } else if (type == ButtonType.transparent) {
      buttonColor = Colors.transparent;
      textColor = Colors.white;
      borderColor = Colors.transparent;
    }

    if (size == ButtonSize.small) {
      fontSize = 20;
      fontWeight = FontWeight.normal;
      paddingVertical = 5;
      paddingHorizontal = 10;
    }

    if (icon == IconType.google) {
      iconPath = 'assets/google.png';
    }

    return Container(
      margin: const EdgeInsets.all(10.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color?>(buttonColor),
          padding: MaterialStateProperty.all<EdgeInsets>(
            EdgeInsets.symmetric(vertical: paddingVertical, horizontal: paddingHorizontal),
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
              side: BorderSide(color: borderColor, width: 2.0),
            ),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != IconType.none)
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Image.asset(
                  iconPath,
                  height: 20,
                ),
              ),
              Flexible(
                child: Text(
                  text,
                  style: TextStyle(fontSize: fontSize, color: textColor, fontWeight: fontWeight),
                  textAlign: TextAlign.center, // Center the text
                ),
              ),
          ],
        ),
      ),
    );
  }
}
