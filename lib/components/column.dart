import 'package:flutter/material.dart';

class CustomColumn extends StatelessWidget {
  final List<Widget> children;

  const CustomColumn({
    Key? key,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children.map((child) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8.0),
          child: child,
        );
      }).toList(),
    );
  }
}
