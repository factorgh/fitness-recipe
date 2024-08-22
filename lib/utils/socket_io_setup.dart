// ignore_for_file: avoid_print, library_prefixes

import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:voltican_fitness/models/notification.dart';

class SocketService {
  IO.Socket? _socket;

  void initSocket() {
    _socket = IO.io(
        'https://fitnessapp.adroit360.com',
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
      final notification = AppNotification.fromMap(data);
      onNotification(notification);
    });
  }

  void dispose() {
    _socket?.disconnect();
  }
}
