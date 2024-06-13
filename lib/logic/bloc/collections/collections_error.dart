import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

const Map<String, CollectionsError> collectionsErrorMapping = {};

@immutable
abstract class CollectionsError {
  final String dialogTitle;
  final String dialogText;

  const CollectionsError({
    required this.dialogTitle,
    required this.dialogText,
  });

  factory CollectionsError.from(FirebaseException exception) {
    if (kDebugMode) {
      print('CollectionsError.from exception 🚀');
      print(exception);
    }

    return collectionsErrorMapping[exception.code.toLowerCase().trim()] ??
        const CollectionsErrorUnknown();
  }
}

@immutable
class CollectionsErrorUnknown extends CollectionsError {
  const CollectionsErrorUnknown()
      : super(
          dialogTitle: 'Challenges error',
          dialogText: 'Unknown challenges error',
        );
}
