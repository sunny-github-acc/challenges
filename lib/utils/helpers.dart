import 'dart:async';
import 'package:flutter/material.dart';

bool isValidEmail(String email) {
  if (email.isEmpty) {
    return false;
  }

  const String emailRegex = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  final RegExp regex = RegExp(emailRegex);

  return regex.hasMatch(email);
}

class Debounce {
  VoidCallback? action;
  bool _isRunning = false;
  bool _isLoading = false;
  final int milliseconds;
  final StreamController<bool> _loadingController =
      StreamController<bool>.broadcast();

  Debounce({this.milliseconds = 111});

  Stream<bool> get loadingStream => _loadingController.stream; // Add this line

  bool get isLoading => _isLoading;

  run(VoidCallback action) {
    if (_isRunning) {
      return;
    }

    _isRunning = true;
    _isLoading = true;
    _loadingController.add(true);
    action();

    Timer(Duration(milliseconds: milliseconds), () {
      _isRunning = false;
      _isLoading = false;
      _loadingController.add(false);
    });
  }

  void dispose() {
    _loadingController.close();
  }
}


// class LoadingButton extends StatefulWidget {
//   final VoidCallback onPressed;
//   final String text;
//   final IconType icon;
//   final Stream<bool>? loadingStream;
//   final ButtonType type;
//   final ButtonSize size;

//   const LoadingButton({
//     Key? key,
//     required this.onPressed,
//     required this.text,
//     this.loadingStream,
//     this.type = ButtonType.primary,
//     this.size = ButtonSize.normal,
//     this.icon = IconType.none,
//   }) : super(key: key);

//   @override
//   LoadingButtonState createState() => LoadingButtonState();
// }

// class LoadingButtonState extends State<LoadingButton> {
//   final StreamController<bool> _internalLoadingController =
//       StreamController<bool>.broadcast();

//   @override
//   Widget build(BuildContext context) {
//     Stream<bool> internalLoadingStream =
//         widget.loadingStream ?? _internalLoadingController.stream;

//     return StreamBuilder<bool>(
//       stream: internalLoadingStream,
//       initialData: false,
//       builder: (context, snapshot) {
//         return CustomButton(
//           onPressed: widget.onPressed,
//           text: widget.text,
//           type: widget.type,
//           icon: widget.icon,
//           isLoading: snapshot.data ?? false,
//         );
//       },
//     );
//   }

//   @override
//   void dispose() {
//     if (widget.loadingStream == null) {
//       _internalLoadingController.close();
//     }
//     super.dispose();
//   }
// }
