// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:voltican_fitness/classes/dio_client.dart';

Future<void> sendEmail(
    String from, String to, String subject, String text) async {
  final DioClient client = DioClient();

  try {
    final response = await client.dio.post(
      "email/send-email",
      options: Options(
        headers: {'Content-Type': 'application/json'},
      ),
      data: json.encode({
        'from': from,
        'to': to,
        'subject': subject,
        'text': text,
      }),
    );

    if (response.statusCode == 200) {
      print('Email sent successfully');
    } else {
      print('Failed to send email: ${response.data}');
    }
  } catch (e) {
    print('Error sending email: $e');
  }
}
