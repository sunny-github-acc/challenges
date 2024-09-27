import 'package:flutter/foundation.dart';

const Map<String, TribesError> tribesErrorMapping = {
  'already-exists': TribesErrorTribeAlreadyExists(),
  'no-data-found': TribesErrorNoDataFound(),
  'member-already-in-tribe': TribesErrorMemberAlreadyInTribe(),
};

@immutable
abstract class TribesError {
  final String dialogTitle;
  final String dialogText;

  const TribesError({
    required this.dialogTitle,
    required this.dialogText,
  });

  factory TribesError.from(exception) {
    return tribesErrorMapping[exception] ?? const TribesErrorUnknown();
  }
}

@immutable
class TribesErrorUnknown extends TribesError {
  const TribesErrorUnknown()
      : super(
          dialogTitle: 'Unknown Error',
          dialogText: 'Unknown Tribes Error',
        );
}

@immutable
class TribesErrorTribeAlreadyExists extends TribesError {
  const TribesErrorTribeAlreadyExists()
      : super(
          dialogTitle: 'Tribe Already Exists',
          dialogText: 'The name of the tribe already exists',
        );
}

@immutable
class TribesErrorNoDataFound extends TribesError {
  const TribesErrorNoDataFound()
      : super(
          dialogTitle: 'Tribe Not Found',
          dialogText: 'The tribe you are looking for does not exist',
        );
}

@immutable
class TribesErrorMemberAlreadyInTribe extends TribesError {
  const TribesErrorMemberAlreadyInTribe()
      : super(
          dialogTitle: 'Already a Tribe Member',
          dialogText: 'You are already a member of this tribe',
        );
}
