import 'package:challenges/logic/bloc/tribes/tribes_error.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class TribesState {
  final bool isLoading;
  final String? success;
  final TribesError? error;

  const TribesState({
    required this.isLoading,
    this.success,
    this.error,
  });
}

@immutable
class TribesStateEmpty extends TribesState {
  const TribesStateEmpty()
      : super(
          isLoading: false,
        );

  @override
  String toString() => '🚀 TribesStateEmpty';
}

@immutable
class TribesStateAdding extends TribesState {
  const TribesStateAdding()
      : super(
          isLoading: true,
        );

  @override
  String toString() => '🚀 TribesStateAdding';
}

@immutable
class TribesStateAdded extends TribesState {
  const TribesStateAdded({
    required final String success,
  }) : super(
          isLoading: false,
          success: success,
        );

  @override
  String toString() => '🚀 TribesStateAdded: (success: $success)';
}

@immutable
class TribesStateJoining extends TribesState {
  const TribesStateJoining()
      : super(
          isLoading: true,
        );

  @override
  String toString() => '🚀 TribesStateJoining';
}

@immutable
class TribesStateJoined extends TribesState {
  const TribesStateJoined({
    required final String success,
  }) : super(
          isLoading: false,
          success: success,
        );

  @override
  String toString() => '🚀 TribesStateJoined: (success: $success)';
}

@immutable
class TribesStateError extends TribesState {
  const TribesStateError({
    required final TribesError error,
  }) : super(
          isLoading: false,
          error: error,
        );

  @override
  String toString() => '🚀 TribesStateError: (error: $error)';
}

@immutable
class TribesStateGetting extends TribesState {
  const TribesStateGetting()
      : super(
          isLoading: true,
        );

  @override
  String toString() => '🚀 TribesStateGetting';
}

@immutable
class TribesStateGot extends TribesState {
  final List<String> tribes;

  const TribesStateGot({
    required this.tribes,
  }) : super(
          isLoading: false,
        );

  @override
  String toString() => '🚀 TribesStateGot: (tribes: $tribes)';
}

extension GetTribes on TribesState {
  List<String> get tribes {
    final cls = this;
    if (cls is TribesStateGot) {
      return cls.tribes;
    } else {
      return [];
    }
  }
}
