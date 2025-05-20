import 'package:challenges/components/text.dart';
import 'package:flutter/material.dart';

class Modal {
  static void show(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: CustomText(text: title),
          content: CustomText(text: content),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const CustomText(text: 'Close'),
            ),
          ],
        );
      },
    );
  }
}
