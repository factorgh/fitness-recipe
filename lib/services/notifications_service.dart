// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:fit_cibus/classes/dio_client.dart';
import 'package:fit_cibus/models/notification.dart';

// Import your AppNotification model

class NotificationServiceSub {
  final DioClient client = DioClient();

  Future<void> createNotification(AppNotification notification) async {
    try {
      await client.dio.post('/notifications', data: notification.toMap());
    } on DioException catch (e) {
      // Handle error
      throw Exception('Failed to create notification: ${e.message}');
    }
  }

  Future<List<AppNotification>> getNotifications(String userId) async {
    try {
      final response =
          await client.dio.get('/notifications/notifications/$userId');
      final List<dynamic> data = response.data;

      print('Received Data: $data');

      // Check if the data is a List and contains expected data
      List<AppNotification> notifications = data.map((json) {
        print('Parsing JSON: $json');

        // Add a check for the type of json
        if (json is Map<String, dynamic>) {
          return AppNotification.fromMap(json);
        } else {
          throw Exception('Unexpected data format');
        }
      }).toList();

      print("------notifications for map--------$notifications");
      return notifications;
    } on DioException catch (e) {
      // Handle error
      print('DioException: $e');
      throw Exception('Failed to fetch notifications: $e');
    } catch (e) {
      // Handle other errors
      print('Error: $e');
      throw Exception('Failed to fetch notifications: $e');
    }
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      await client.dio
          .patch('/notifications/$notificationId', data: {'isRead': true});
    } on DioException catch (e) {
      // Handle error
      throw Exception('Failed to mark notification as read: ${e.message}');
    }
  }
}
