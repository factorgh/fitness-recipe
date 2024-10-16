// import 'dart:convert';
// import 'dart:io';
// import 'package:dio/dio.dart';
// import 'package:http/http.dart' as http;

// Future<String> uploadImageToCloudinary(File file) async {
//   const uploadUrl = 'https://api.cloudinary.com/v1_1/daq5dsnqy/image/upload';
//   const uploadPreset = 'ml_default';

//   final request = http.MultipartRequest('POST', Uri.parse(uploadUrl))
//     ..fields['upload_preset'] = uploadPreset
//     ..files.add(http.MultipartFile(
//       'file',
//       file.readAsBytes().asStream(),
//       file.lengthSync(),
//       filename: file.path.split('/').last,
//       contentType: DioMediaType('image', 'jpeg'), // Adjust based on file type
//     ));

//   try {
//     final response = await request.send();
//     final responseData = await response.stream.bytesToString();
//     final data = jsonDecode(responseData);

//     if (response.statusCode == 200) {
//       return data['secure_url']; // URL of the uploaded image
//     } else {
//       throw Exception('Failed to upload image');
//     }
//   } catch (e) {
//     print('Error uploading image: $e');
//     rethrow;
//   }
// }

// // Future<void> sendImageUrlToBackend(String imageUrl) async {
// //   final response = await http.post(
// //     Uri.parse('http://yourapi.com/save-image-url'),
// //     headers: {'Content-Type': 'application/json'},
// //     body: jsonEncode({'imageUrl': imageUrl}),
// //   );
// //   if (response.statusCode == 200) {
// //     print('Image URL saved successfully');
// //   } else {
// //     print('Failed to save image URL');
// //   }
// // }
