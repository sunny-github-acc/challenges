import 'package:challenges/utils/colors.dart';
import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  final Widget child;
  final double? margin;
  final double? padding;
  final double marginHorizontal;
  final double paddingHorizontal;
  final double marginVertical;
  final double paddingVertical;
  final double? paddingTop;
  final double? paddingBottom;
  final double? paddingLeft;
  final double? paddingRight;
  final double? marginTop;
  final double? marginBottom;
  final double? marginLeft;
  final double? marginRight;
  final double? width;
  final bool isSingleChildScrollView;
  final bool isFull;
  final bool isFullHeight;
  final bool isFullWidth;

  const CustomContainer({
    Key? key,
    required this.child,
    this.margin,
    this.padding,
    this.marginHorizontal = 0,
    this.paddingHorizontal = 12,
    this.marginVertical = 0,
    this.paddingVertical = 16,
    this.paddingTop,
    this.paddingBottom,
    this.paddingLeft,
    this.paddingRight,
    this.marginTop,
    this.marginBottom,
    this.marginLeft,
    this.marginRight,
    this.width,
    this.isSingleChildScrollView = true,
    this.isFull = false,
    this.isFullHeight = false,
    this.isFullWidth = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    const double appBarHeight = kToolbarHeight;
    final double availableHeight = screenHeight -
        statusBarHeight -
        appBarHeight -
        (padding ??
            ((paddingTop ?? paddingVertical / 2) +
                (paddingBottom ?? paddingVertical / 2)));

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SizedBox(
        height: (isFull || isFullHeight) ? screenHeight : availableHeight,
        width: (isFull || isFullWidth) ? screenWidth : width,
        child: Container(
          margin: EdgeInsets.only(
            left: margin ?? marginHorizontal,
            right: margin ?? marginHorizontal,
            top: margin ?? marginTop ?? marginVertical,
            bottom: margin ?? marginBottom ?? marginVertical,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                colorMap['white']!,
                colorMap['white']!,
              ],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              left: padding ?? paddingHorizontal,
              right: padding ?? paddingHorizontal,
              top: padding ?? paddingTop ?? paddingVertical,
              bottom: padding ?? paddingBottom ?? paddingVertical,
            ),
            child: isSingleChildScrollView
                ? SingleChildScrollView(
                    child: child,
                  )
                : child,
          ),
        ),
      ),
    );
  }
}
