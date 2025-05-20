import 'package:challenges/components/container_gradient.dart';
import 'package:flutter/material.dart';

class CustomModal extends StatelessWidget {
  final Widget child;

  const CustomModal({
    Key? key,
    required this.child,
  }) : super(key: key);

  void show(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        return Align(
          alignment: Alignment.centerLeft,
          child: CustomContainer(
            width: MediaQuery.of(context).size.width * 0.8,
            isFullHeight: true,
            isSingleChildScrollView: true,
            paddingTop: 32,
            child: child,
          ),
        );
      },
      transitionBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
      ) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-1, 0),
            end: const Offset(0, 0),
          ).animate(animation),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
