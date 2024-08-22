// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:voltican_fitness/models/notification.dart';
import 'package:voltican_fitness/providers/user_provider.dart';
import 'package:voltican_fitness/services/notifications_service.dart';
import 'package:voltican_fitness/utils/socket_io_setup.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  late NotificationServiceSub _notificationService;
  late SocketService _socketService;
  late Future<List<AppNotification>> _notificationsFuture;

  @override
  void initState() {
    super.initState();
    _notificationService = NotificationServiceSub();
    _socketService = SocketService();
    _socketService.initSocket();

    final user = ref.read(userProvider);
    if (user != null) {
      _notificationsFuture = _notificationService.getNotifications(user.id);

      _socketService.listenForNotifications(user.id, (notification) {
        setState(() {
          _notificationsFuture = _notificationService.getNotifications(user.id);
        });
      });
    } else {
      _notificationsFuture = Future.value([]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<AppNotification>>(
        future: _notificationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());

            // } else if (snapshot.hasError) {
            //   return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData ||
              snapshot.data!.isEmpty ||
              snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset("assets/animations/notify.json"),
                  const Text(
                    'No notifications available',
                    style: TextStyle(color: Colors.red, fontSize: 15),
                  ),
                ],
              ),
            );
          } else {
            final notifications = snapshot.data!;
            print('----------noti-------$notifications');

            return ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  leading: const Icon(Icons.notifications, color: Colors.blue),
                  title: Text(
                    notification.message,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(notification.createdAt.toString()),
                      const SizedBox(height: 4),
                      Text(
                        _formatTimestamp(notification.createdAt),
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                  tileColor:
                      notification.isRead ? Colors.grey[200] : Colors.white,
                  onTap: () async {
                    await _notificationService
                        .markNotificationAsRead(notification.id);
                    setState(() {
                      _notificationsFuture = _notificationService
                          .getNotifications(ref.read(userProvider)!.id);
                    });
                  },
                );
              },
            );
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _socketService.dispose();
    super.dispose();
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 1) {
      return '${timestamp.month}/${timestamp.day}/${timestamp.year}';
    } else if (difference.inHours > 1) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 1) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }
}
