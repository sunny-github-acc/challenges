import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:mockito/mockito.dart';
import 'dart:async';

import 'package:challenges/logic/bloc/internet_bloc.dart';

class MockConnectivity extends Mock implements Connectivity {
  final StreamController<ConnectivityResult> _connectivityStreamController =
      StreamController<ConnectivityResult>();

  @override
  Stream<ConnectivityResult> get onConnectivityChanged =>
      _connectivityStreamController.stream;

  void simulateConnectivityChange(ConnectivityResult result) {
    _connectivityStreamController.add(result);
  }

  @override
  Future<ConnectivityResult> checkConnectivity() async {
    return ConnectivityResult.none;
  }
}

void main() {
  group('Testing Internet Bloc', () {
    late MockConnectivity mockConnectivity;
    late InternetBloc internetBloc;

    setUp(() {
      mockConnectivity = MockConnectivity();
      internetBloc = InternetBloc(connectivity: mockConnectivity);
    });

    tearDown(() {
      internetBloc.close();
    });

    test('initial state is InternetDisconnected', () {
      expect(internetBloc.state, equals(const InternetDisconnected()));
    });

    blocTest<InternetBloc, InternetState>(
      'returns InternetDisconnected when InternetDisconnectedEvent is added',
      build: () => internetBloc,
      act: (bloc) => bloc.add(InternetDisconnectedEvent()),
      expect: () => [const InternetDisconnected()],
    );

    blocTest<InternetBloc, InternetState>(
      'returns InternetConnected when InternetConnectedEvent is added',
      build: () => internetBloc,
      act: (bloc) => bloc.add(InternetConnectedEvent()),
      expect: () => [const InternetConnected()],
    );

    blocTest<InternetBloc, InternetState>(
      'returns InternetConnected and InternetDisconnected when InternetConnectedEvent and InternetDisconnectedEvent are added',
      build: () => internetBloc,
      act: (bloc) => {
        bloc.add(InternetConnectedEvent()),
        bloc.add(InternetDisconnectedEvent())
      },
      expect: () => [
        const InternetConnected(),
        const InternetDisconnected(),
      ],
    );

    blocTest<InternetBloc, InternetState>(
      'emits InternetConnected when ConnectivityResult.wifi is emitted',
      build: () => internetBloc,
      act: (bloc) {
        mockConnectivity.simulateConnectivityChange(ConnectivityResult.wifi);
      },
      expect: () => [const InternetConnected()],
    );

    blocTest<InternetBloc, InternetState>(
      'emits InternetConnected when ConnectivityResult.mobile is emitted',
      build: () => internetBloc,
      act: (_) {
        mockConnectivity.simulateConnectivityChange(ConnectivityResult.mobile);
      },
      expect: () => [const InternetConnected()],
    );

    blocTest<InternetBloc, InternetState>(
      'emits InternetDisconnected when ConnectivityResult.none is emitted',
      build: () => internetBloc,
      act: (_) {
        mockConnectivity.simulateConnectivityChange(ConnectivityResult.none);
      },
      expect: () => [const InternetDisconnected()],
    );

    blocTest<InternetBloc, InternetState>(
      'emits InternetDisconnected after closing the bloc',
      build: () => internetBloc,
      act: (bloc) => bloc.close(),
      expect: () => [],
    );
  });
}
