import 'firebase_options.dart';
import 'package:challenges/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // https://pub.dev/packages/hydrated_bloc

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // try delete this line
  );

  runApp(const MyApp());
}
