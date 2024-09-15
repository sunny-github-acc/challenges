import 'package:challenges/components/text.dart';
import 'package:flutter/material.dart';

import 'package:challenges/utils/colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final double? fontSize;
  final bool? centerTitle;
  final List<Widget>? actions;
  final Widget? leftButton;

  const CustomAppBar({
    Key? key,
    this.title,
    this.leftButton,
    this.actions,
    this.fontSize = 24,
    this.centerTitle = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: CustomText(
        text: title ?? '',
        style: TextStyle(
          fontSize: fontSize,
          color: colorMap['white']!,
        ),
      ),
      centerTitle: centerTitle,
      backgroundColor: colorMap['blue'],
      actions: actions?.map((action) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10.0,
            vertical: 10.0,
          ),
          child: action,
        );
      }).toList(),
      leading: leftButton,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
