import 'package:flutter/foundation.dart';

const Map<String, PrioritiesError> prioritiesErrorMapping = {
  'no-data-found': PrioritiesErrorNoDataFound(),
};

@immutable
abstract class PrioritiesError {
  final String dialogTitle;
  final String dialogText;

  const PrioritiesError({
    required this.dialogTitle,
    required this.dialogText,
  });

  factory PrioritiesError.from(exception) {
    return prioritiesErrorMapping[exception] ?? const PrioritiesErrorUnknown();
  }
}

@immutable
class PrioritiesErrorUnknown extends PrioritiesError {
  const PrioritiesErrorUnknown()
      : super(
          dialogTitle: 'Unknown Error',
          dialogText: 'Unknown Priorities Error',
        );
}

@immutable
class PrioritiesErrorNoDataFound extends PrioritiesError {
  const PrioritiesErrorNoDataFound()
      : super(
          dialogTitle: 'Priorities Not Found',
          dialogText: 'The priorities you are looking for does not exist',
        );
}
