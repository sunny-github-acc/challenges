import 'package:flutter/foundation.dart';

const Map<String, CollectionError> collectionErrorMapping = {};

@immutable
abstract class CollectionError {
  final String dialogTitle;
  final String dialogText;

  const CollectionError({
    required this.dialogTitle,
    required this.dialogText,
  });

  factory CollectionError.from(String exception) {
    if (kDebugMode) {
      print('CollectionError.from exception 🚀');
      print(exception);
    }

    return CollectionErrorUnknown(exception);
  }
}

@immutable
class CollectionErrorUnknown extends CollectionError {
  const CollectionErrorUnknown(String exception)
      : super(
          dialogTitle: 'Error:',
          dialogText: exception,
        );
}
