import 'package:challenges/components/circular_progress_indicator.dart';
import 'package:challenges/components/column.dart';
import 'package:challenges/components/text.dart';
import 'package:challenges/utils/colors.dart';
import 'package:flutter/material.dart';

import 'package:challenges/components/row.dart';

enum ButtonType {
  primary,
  secondary,
  danger,
}

enum ButtonSize {
  normal,
  small,
}

enum IconType {
  none,
  google,
  register,
  signIn,
  close,
  info,
}

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String? text;
  final ButtonType type;
  final ButtonSize size;
  final IconType icon;
  final bool isLoading;
  final bool disabled;
  final bool isFullWidth;

  const CustomButton({
    super.key,
    required this.onPressed,
    this.text,
    this.type = ButtonType.primary,
    this.size = ButtonSize.normal,
    this.icon = IconType.none,
    this.isLoading = false,
    this.disabled = false,
    this.isFullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    double paddingVertical = 10;
    double paddingHorizontal = 20;
    Color buttonColor = colorMap['blue']!;
    Color textColor = colorMap['white']!;
    Color borderColor = colorMap['blue']!;
    double fontSize = 24;
    FontWeight fontWeight = FontWeight.normal;
    String iconPath = '';
    Color? iconColor = colorMap['white'];

    if (type == ButtonType.secondary) {
      buttonColor = colorMap['white']!;
      textColor = colorMap['black']!;
      iconColor = colorMap['black'];
      borderColor = Colors.transparent;
    } else if (type == ButtonType.danger) {
      buttonColor = colorMap['red']!;
      borderColor = colorMap['red']!;
    }

    if (size == ButtonSize.small) {
      fontSize = 20;
      fontWeight = FontWeight.normal;
      paddingVertical = 5;
      paddingHorizontal = 10;
    }

    if (icon == IconType.google) {
      iconPath = 'assets/google.png';
      iconColor = null;
    } else if (icon == IconType.register) {
      iconPath = 'assets/register.png';
    } else if (icon == IconType.signIn) {
      iconPath = 'assets/signIn.png';
    } else if (icon == IconType.close) {
      iconPath = 'assets/close.png';
    } else if (icon == IconType.info) {
      iconPath = 'assets/info.png';
    }

    ButtonStyle buttonStyle = ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color?>(buttonColor),
      padding: MaterialStateProperty.all<EdgeInsets>(
        EdgeInsets.symmetric(
          vertical: paddingVertical,
          horizontal: paddingHorizontal,
        ),
      ),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
          side: BorderSide(
            color: borderColor,
            width: 2.0,
          ),
        ),
      ),
    );

    int iconLength = icon != IconType.none ? 1 : 0;
    int isLoadingLength = isLoading ? 1 : 0;
    int buttonItemLength = iconLength + 1 + isLoadingLength;

    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      child: ElevatedButton(
        onPressed: disabled ? null : onPressed,
        style: buttonStyle,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: CustomRow(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
            spacing: SpacingType.medium,
            flex: List.generate(buttonItemLength, (index) => 0),
            children: [
              if (icon != IconType.none)
                Image.asset(
                  iconPath,
                  height: fontSize,
                  width: fontSize,
                  color: iconColor,
                ),
              if (text != null && text!.isNotEmpty)
                CustomText(
                  text: text!,
                  style: TextStyle(
                    fontSize: fontSize,
                    color: textColor,
                    fontWeight: fontWeight,
                  ),
                ),
              if (isLoading)
                SizedBox(
                  height: fontSize - 5,
                  width: fontSize - 5,
                  child: const CustomCircularProgressIndicator(
                    strokeWidth: 2.5,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
