import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationDetailsPage extends StatelessWidget {
  final String notiText;
  final DateTime createdAt;
  final String createdBy;
  final bool isRead;
  final String type;

  const NotificationDetailsPage({
    super.key,
    required this.notiText,
    required this.createdAt,
    required this.createdBy,
    required this.isRead,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Notification Details',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              type,
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              notiText,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Sent by: $createdBy',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Received on: ${DateFormat.yMMMMd().format(createdAt)} at ${DateFormat.jm().format(createdAt)}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Status',
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  isRead ? Icons.done : Icons.markunread,
                  color: isRead ? Colors.green : Colors.red,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  isRead ? 'Read' : 'Unread',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: isRead ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 37, 52, 39),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Back',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
