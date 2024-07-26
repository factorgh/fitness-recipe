import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  final List<NotificationItem> notifications = [
    NotificationItem(
      title: 'New Message from John',
      description: 'Hey, are we still meeting today?',
      timestamp: DateTime.now().subtract(Duration(minutes: 5)),
    ),
    NotificationItem(
      title: 'App Update Available',
      description: 'Version 2.1.0 is now available.',
      timestamp: DateTime.now().subtract(Duration(hours: 1)),
    ),
    NotificationItem(
      title: 'Reminder: Meeting at 3 PM',
      description: 'Don\'t forget your meeting today.',
      timestamp: DateTime.now().subtract(Duration(days: 1)),
    ),
    // Add more notifications here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 20, bottom: 10, left: 10),
                child: Text(
                  'New Alerts',
                  style: TextStyle(color: Colors.lightBlue, fontSize: 20),
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return NotificationTile(notification: notification);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class NotificationItem {
  final String title;
  final String description;
  final DateTime timestamp;

  NotificationItem({
    required this.title,
    required this.description,
    required this.timestamp,
  });
}

class NotificationTile extends StatelessWidget {
  final NotificationItem notification;

  NotificationTile({required this.notification});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      leading: Icon(Icons.notifications, color: Colors.blue),
      title: Text(
        notification.title,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(notification.description),
          SizedBox(height: 4),
          Text(
            _formatTimestamp(notification.timestamp),
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
      tileColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
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
