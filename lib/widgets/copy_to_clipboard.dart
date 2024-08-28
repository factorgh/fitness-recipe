import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CopyToClipboardWidget extends StatelessWidget {
  final String textToCopy;

  const CopyToClipboardWidget({super.key, required this.textToCopy});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.brown[50],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  'Trainer Code',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.orange),
                ),
                Text(textToCopy,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: () {
                    final text =
                        "TrainerCode: $textToCopy - App Info: Fitness Recipe v1.0.Paste link to your recipe app on Google Play Store or App Store. https://play.google.com/store/apps/";
                    Clipboard.setData(ClipboardData(text: text));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Copied to clipboard!')),
                    );
                  },
                ),
                IconButton(onPressed: () {}, icon: const Icon(Icons.share))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
