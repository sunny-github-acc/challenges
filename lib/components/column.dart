import 'package:flutter/material.dart';

enum SpacingType {
  large,
  medium,
  small,
  none,
}

Map<SpacingType, double> spacingMap = {
  SpacingType.large: 24.0,
  SpacingType.medium: 16.0,
  SpacingType.small: 8.0,
  SpacingType.none: 0,
};

class CustomColumn extends StatelessWidget {
  final List<Widget> children;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final SpacingType spacing;

  const CustomColumn({
    Key? key,
    required this.children,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.spacing = SpacingType.none,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: children.map(
        (child) {
          final bool isLastChild =
              children.indexOf(child) == children.length - 1;
          double bottom = isLastChild ? 0 : spacingMap[spacing]!;

          return Container(
            margin: EdgeInsets.only(
              bottom: bottom,
            ),
            child: child,
          );
        },
      ).toList(),
    );
  }
}
