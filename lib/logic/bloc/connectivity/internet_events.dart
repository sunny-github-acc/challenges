part of 'internet_bloc.dart';

abstract class InternetEvent {
  const InternetEvent();
}

class InternetDisconnectedEvent extends InternetEvent {}

class InternetConnectedEvent extends InternetEvent {}
