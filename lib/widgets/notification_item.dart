import 'package:flutter/material.dart';

class NotificationItem extends StatelessWidget {
  final String notiText;
  final DateTime createdAt;
  final bool isRead;
  final IconData notiIcon;
  final String notificationId;
  final Future<void> Function(String id) onNotificationTap;

  const NotificationItem({
    super.key,
    required this.notiIcon,
    required this.notiText,
    required this.createdAt,
    required this.isRead,
    required this.notificationId,
    required this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await onNotificationTap(notificationId);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        decoration: BoxDecoration(
          color: isRead ? Colors.grey[200] : Colors.white,
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade300),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black54),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Icon(
                notiIcon,
                size: 20,
                color: Colors.black87,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notiText,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    _formatTimestamp(createdAt),
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
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
