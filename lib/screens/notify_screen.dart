// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:voltican_fitness/models/notification.dart';
import 'package:voltican_fitness/providers/user_provider.dart';
import 'package:voltican_fitness/screens/notification_detail_screen.dart';
import 'package:voltican_fitness/services/notifications_service.dart';
import 'package:voltican_fitness/utils/socket_io_setup.dart';
import 'package:voltican_fitness/widgets/notification_item.dart';

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
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: () {},
          ),
        ],
      ),
      body: FutureBuilder<List<AppNotification>>(
        future: _notificationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
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

                return NotificationItem(
                  notiIcon: Icons.notifications,
                  notiText: notification.message,
                  createdAt: notification.createdAt,
                  isRead: notification.isRead,
                  notificationId: notification.id,
                  onNotificationTap: (message) async {
                    // Assume this is inside your NotificationItem onTap method

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NotificationDetailsPage(
                          type: notification.type,
                          notiText: notification.message,
                          createdAt: notification.createdAt,
                          createdBy:
                              'Trainer', // You can dynamically pass this value
                          isRead: notification.isRead,
                        ),
                      ),
                    );
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
}
