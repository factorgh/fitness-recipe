// ignore_for_file: avoid_print

import 'package:fit_cibus/providers/user_provider.dart';
import 'package:fit_cibus/screens/all_meal_plan_trainee.dart';
import 'package:fit_cibus/widgets/reusable_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class NotificationDetailsPage extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.read(userProvider);
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
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                if (user?.role == "0") {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AllMealPlanTrainee()));
                } else {
                  print("print for traibner nav");
                }
              },
              icon: const Icon(Icons.view_agenda_outlined))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              type,
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              notiText,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.redAccent,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Sent by: $createdBy',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Received on: ${DateFormat.yMMMMd().format(createdAt)} at ${DateFormat.jm().format(createdAt)}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.redAccent,
              ),
            ),
            const SizedBox(height: 24),
            // Text(
            //   'Status',
            //   style: Theme.of(context).textTheme.headlineSmall!.copyWith(
            //         color: Colors.black,
            //         fontWeight: FontWeight.w600,
            //       ),
            // ),
            // const SizedBox(height: 12),
            // Row(
            //   children: [
            //     Icon(
            //       isRead ? Icons.done : Icons.markunread,
            //       color: isRead ? Colors.green : Colors.red,
            //       size: 24,
            //     ),
            //     const SizedBox(width: 8),
            //     Text(
            //       isRead ? 'Read' : 'Unread',
            //       style: TextStyle(
            //         fontSize: 16,
            //         fontWeight: FontWeight.w500,
            //         color: isRead ? Colors.green : Colors.red,
            //       ),
            //     ),
            //   ],
            // ),
            const Spacer(),
            Reusablebutton(
                text: "Back",
                onPressed: () {
                  Navigator.of(context).pop();
                })
          ],
        ),
      ),
    );
  }
}
