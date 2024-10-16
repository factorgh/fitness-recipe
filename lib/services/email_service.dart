// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fit_cibus/classes/dio_client.dart';

class EmailService {
  Future<void> sendEmail(
    String to,
    String userEmail,
  ) async {
    final DioClient client = DioClient();

    try {
      final response = await client.dio.post(
        "/email/send-email",
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
        data: json.encode({
          'to': to,
          'userEmail': userEmail,
        }),
      );

      if (response.statusCode == 200) {
        print('Email sent successfully');
      } else {
        print('Failed to send email: ${response.data}');
      }
    } catch (e) {
      print('Error sending email: $e');
      throw Exception(e);
    }
  }
}
