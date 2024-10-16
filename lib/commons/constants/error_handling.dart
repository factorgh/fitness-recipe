import 'dart:convert';

// import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' as dio;
import 'package:fit_cibus/utils/show_snackbar.dart';
import 'package:flutter/material.dart';

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
    case 403:
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
