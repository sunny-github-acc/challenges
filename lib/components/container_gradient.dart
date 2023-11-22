import 'package:flutter/material.dart';

class ContainerGradient extends StatelessWidget {
  final Widget child;
  final double margin;
  final double padding;

  const ContainerGradient(
      {Key? key, required this.child, this.margin = 0, this.padding = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          margin: EdgeInsets.all(margin),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white,
                Colors.white,
              ],
            ),
          ),
          child: Padding(padding: EdgeInsets.all(padding), child: child),
        ));
  }
}
