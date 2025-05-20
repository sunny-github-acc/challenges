import 'dart:async';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

part 'internet_state.dart';
part 'internet_events.dart';

class InternetBloc extends Bloc<InternetEvent, InternetState> {
  final Connectivity connectivity;
  late StreamSubscription connectivityStreamSubscription;

  InternetBloc({required this.connectivity})
      : super(const InternetDisconnected()) {
    on<InternetDisconnectedEvent>(
        (event, emit) => emit(const InternetDisconnected()));
    on<InternetConnectedEvent>(
        (event, emit) => emit(const InternetConnected()));

    connectivityStreamSubscription =
        connectivity.onConnectivityChanged.listen((result) {
      if (result == ConnectivityResult.none) {
        add(InternetDisconnectedEvent());
      } else {
        add(InternetConnectedEvent());
      }
    });
  }

  @override
  Future<void> close() {
    connectivityStreamSubscription.cancel();
    return super.close();
  }
}
