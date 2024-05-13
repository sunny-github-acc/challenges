part of 'internet_bloc.dart';

@immutable
class InternetState {
  final bool isConnected;

  const InternetState({
    required this.isConnected,
  });
}

class InternetConnected extends InternetState {
  const InternetConnected() : super(isConnected: true);
}

class InternetDisconnected extends InternetState {
  const InternetDisconnected() : super(isConnected: false);
}
