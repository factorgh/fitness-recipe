// ignore_for_file: avoid_print, library_prefixes

import 'package:fit_cibus/models/notification.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  IO.Socket? _socket;

  void dispose() {
    _socket?.disconnect();
  }

  void initSocket() {
    _socket = IO.io(
        'https://fitnessapp.adroit360.com/api/v1/notifications/notifications',
        IO.OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .build());

    _socket!.onConnect((_) {
      print('Connected to socket server');
    });

    _socket!.onDisconnect((_) {
      print('Disconnected from socket server');
    });
  }

  void listenForNotifications(
      String userId, Function(AppNotification) onNotification) {
    _socket?.on('notification-$userId', (data) {
      print('Received socket data: $data');
      final notification = AppNotification.fromJson(data);
      onNotification(notification);
    });
  }
}
