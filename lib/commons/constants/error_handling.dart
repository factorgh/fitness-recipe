import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
import 'package:voltican_fitness/utils/show_snackbar.dart';
import 'package:dio/dio.dart' as dio;

void httpErrorHandle({
  required dio.Response response,
  required BuildContext context,
  required VoidCallback onSuccess,
}) {
  switch (response.statusCode) {
    case 200:
      onSuccess();
      break;
    case 400:
      showSnack(context, jsonDecode(response.data)['message']);
      break;
    case 404:
      showSnack(context, jsonDecode(response.data)['message']);
      break;
    case 500:
      showSnack(context, jsonDecode(response.data)['message']);
      break;
    default:
      showSnack(context, response.data);
  }
}
