import 'package:flutter/material.dart';

class CustomRow extends StatelessWidget {
  final List<Widget> children;

  const CustomRow({
    Key? key,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: children.map((child) {
        return Container(
          margin: const EdgeInsets.only(right: 3.0),
          child: child,
        );
      }).toList(),
    );
  }
}
