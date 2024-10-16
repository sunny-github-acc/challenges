import 'package:challenges/logic/bloc/priorities/priorities_error.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class PrioritiesState {
  final bool isLoading;

  const PrioritiesState({
    required this.isLoading,
  });
}

@immutable
class PrioritiesStateEmpty extends PrioritiesState {
  const PrioritiesStateEmpty()
      : super(
          isLoading: false,
        );

  @override
  String toString() => '🚀 PrioritiesStateEmpty';
}

@immutable
class PrioritiesStateAdding extends PrioritiesState {
  const PrioritiesStateAdding()
      : super(
          isLoading: true,
        );

  @override
  String toString() => '🚀 PrioritiesStateAdding';
}

@immutable
class PrioritiesStateAdded extends PrioritiesState {
  final String priorities;

  const PrioritiesStateAdded({
    required this.priorities,
  }) : super(
          isLoading: false,
        );

  @override
  String toString() => '🚀 PrioritiesStateAdded: (priorities: $priorities)';
}

@immutable
class PrioritiesStateError extends PrioritiesState {
  final PrioritiesError error;

  const PrioritiesStateError({
    required this.error,
  }) : super(
          isLoading: false,
        );

  @override
  String toString() => '🚀 PrioritiesStateError: (error: $error)';
}

@immutable
class PrioritiesStateGetting extends PrioritiesState {
  const PrioritiesStateGetting()
      : super(
          isLoading: true,
        );

  @override
  String toString() => '🚀 PrioritiesStateGetting';
}

@immutable
class PrioritiesStateGot extends PrioritiesState {
  final String priorities;

  const PrioritiesStateGot({
    required this.priorities,
  }) : super(
          isLoading: false,
        );

  @override
  String toString() => '🚀 PrioritiesStateGot: (priorities: $priorities)';
}

extension GetPriorities on PrioritiesState {
  String? get priorities {
    if (this is PrioritiesStateAdded) {
      return (this as PrioritiesStateAdded).priorities;
    } else if (this is PrioritiesStateGot) {
      return (this as PrioritiesStateGot).priorities;
    }
    return null;
  }
}
