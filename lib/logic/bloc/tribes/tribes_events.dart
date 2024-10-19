import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class TribesEvent {
  const TribesEvent();
}

@immutable
class TribesEventAddTribe implements TribesEvent {
  final String tribe;
  final User? user;

  const TribesEventAddTribe({
    required this.tribe,
    required this.user,
  });
}

@immutable
class TribesEventJoinTribe implements TribesEvent {
  final String tribe;
  final User? user;

  const TribesEventJoinTribe({
    required this.tribe,
    required this.user,
  });
}

@immutable
class TribesEventResetState implements TribesEvent {
  const TribesEventResetState();
}

@immutable
class TribesEventGetTribes implements TribesEvent {
  final User user;

  const TribesEventGetTribes({
    required this.user,
  });
}
