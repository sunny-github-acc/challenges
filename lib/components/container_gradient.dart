import 'package:flutter/material.dart';

class ContainerGradient extends StatelessWidget {
  final Widget child;

  const ContainerGradient({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.green.shade100,
              Colors.green.shade300,
            ],
          ),
        ),
        child: child,
      )
    );
  }
}