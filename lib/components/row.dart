import 'package:challenges/components/column.dart';
import 'package:flutter/material.dart';

class CustomRow extends StatelessWidget {
  final List<Widget> children;
  final MainAxisSize? mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;
  final SpacingType spacing;
  final List<int>? flex;

  const CustomRow({
    Key? key,
    required this.children,
    this.mainAxisSize,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.spacing = SpacingType.none,
    this.flex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: mainAxisSize ?? MainAxisSize.max,
      children: children.map((child) {
        final int index = children.indexOf(child);
        final bool isLastChild = index == children.length - 1;
        double right = isLastChild ? 0 : spacingMap[spacing]!;
        int flexValue = isLastChild ? 1 : 0;

        return Flexible(
            flex: flex != null ? flex![index] : flexValue,
            child: Container(
              margin: EdgeInsets.only(
                right: right,
              ),
              child: child,
            ));
      }).toList(),
    );
  }
}
