import 'package:flutter/material.dart';

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
    this.fontSize = 30,
    this.centerTitle = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title != null
          ? Text(
              title!,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            )
          : null,
      centerTitle: centerTitle,
      backgroundColor: Colors.green.shade200,
      actions: actions ?? [],
      leading: leftButton,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
