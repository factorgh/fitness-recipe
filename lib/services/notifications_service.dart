import 'package:dio/dio.dart';
import 'package:voltican_fitness/classes/dio_client.dart';
import 'package:voltican_fitness/models/notification.dart';
// Import your AppNotification model

class NotificationServiceSub {
  final DioClient client = DioClient();

  Future<List<AppNotification>> getNotifications(String userId) async {
    try {
      final response = await client.dio.get('/notifications/$userId');
      final List<dynamic> data = response.data;
      return data.map((json) => AppNotification.fromMap(json)).toList();
    } on DioException catch (e) {
      // Handle error
      print(e);
      throw Exception('Failed to fetch notifications:');
    }
  }

  Future<void> createNotification(AppNotification notification) async {
    try {
      await client.dio.post('/notifications', data: notification.toMap());
    } on DioException catch (e) {
      // Handle error
      throw Exception('Failed to create notification: ${e.message}');
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
