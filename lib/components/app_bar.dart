import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;
  final Widget? leftButton;

  const CustomAppBar({
    Key? key,
    this.title,
    this.leftButton,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title != null ? Text(
        title!,
        style: const TextStyle(
          fontSize: 33,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ) : null,
      centerTitle: true,
      backgroundColor: Colors.green.shade200,
      actions: actions ?? [],
      leading: leftButton,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
