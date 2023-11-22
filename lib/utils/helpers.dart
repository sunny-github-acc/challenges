import 'dart:async';
import 'package:flutter/material.dart';

bool isValidEmail(String email) {
  if (email.isEmpty) {
    return false;
  }

  final String emailRegex = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  final RegExp regex = RegExp(emailRegex);

  return regex.hasMatch(email);
}

class Debounce {
  final int milliseconds;
  VoidCallback? action;
  Timer? _timer;

  Debounce({this.milliseconds = 150});

  run(VoidCallback action) {
    if (_timer != null) {
      _timer?.cancel();
    }

    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
