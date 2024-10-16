import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class PrioritiesEvent {
  const PrioritiesEvent();
}

@immutable
class PrioritiesEventAddPriorities implements PrioritiesEvent {
  final String priorities;
  final User? user;

  const PrioritiesEventAddPriorities({
    required this.priorities,
    required this.user,
  });
}

@immutable
class PrioritiesEventGetPriorities implements PrioritiesEvent {
  final User user;

  const PrioritiesEventGetPriorities({
    required this.user,
  });
}
