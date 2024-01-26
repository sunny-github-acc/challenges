import 'package:flutter/material.dart';

class CustomRow extends StatelessWidget {
  final List<Widget> children;
  final MainAxisSize? mainAxisSize;

  const CustomRow({
    Key? key,
    required this.children,
    this.mainAxisSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      // crossAxisAlignment: CrossAxisAlignment.center,
      // mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: mainAxisSize ?? MainAxisSize.max,
      children: children.map((child) {
        return Container(
          margin: const EdgeInsets.only(right: 8.0),
          child: child,
        );
      }).toList(),
    );
  }
}
