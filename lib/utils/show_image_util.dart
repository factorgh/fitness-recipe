import 'package:fit_cibus/utils/show_preview.dart';
import 'package:flutter/material.dart';

class ShowImageUtil {
  static void showImagePreview(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return ShowPreview(imageUrl: imageUrl);
      },
    );
  }
}
