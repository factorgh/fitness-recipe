import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class ConnectivityState {
  final bool isConnected;

  ConnectivityState(this.isConnected);
}

class ConnectivityNotifier extends StateNotifier<ConnectivityState> {
  StreamSubscription<InternetStatus>? _statusListener;

  ConnectivityNotifier() : super(ConnectivityState(false)) {
    _checkInitialConnectivity();
    _listenToStatusChanges();
  }

  Future<void> _checkInitialConnectivity() async {
    bool result = await InternetConnection().hasInternetAccess;
    state = ConnectivityState(result);
  }

  void _listenToStatusChanges() {
    _statusListener =
        InternetConnection().onStatusChange.listen((InternetStatus status) {
      switch (status) {
        case InternetStatus.connected:
          state = ConnectivityState(true);
          break;
        case InternetStatus.disconnected:
          state = ConnectivityState(false);
          break;
      }
    });
  }

  @override
  void dispose() {
    _statusListener?.cancel(); // Cancel the listener safely
    super.dispose();
  }
}

final connectivityProvider =
    StateNotifierProvider<ConnectivityNotifier, ConnectivityState>((ref) {
  return ConnectivityNotifier();
});
