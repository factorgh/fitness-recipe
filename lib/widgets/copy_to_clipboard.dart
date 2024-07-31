import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CopyToClipboardWidget extends StatefulWidget {
  final String textToCopy;

  const CopyToClipboardWidget({super.key, required this.textToCopy});

  @override
  _CopyToClipboardWidgetState createState() => _CopyToClipboardWidgetState();
}

class _CopyToClipboardWidgetState extends State<CopyToClipboardWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OutlinedButton(onPressed: () {}, child: const Text('Get Code')),
        const SizedBox(
          width: 10,
        ),
        Text(widget.textToCopy,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(
          width: 10,
        ),
        IconButton(
          icon: const Icon(Icons.copy),
          onPressed: () {
            final text =
                "TrainerCode: ${widget.textToCopy} - App Info: Fitness Recipe v1.0.Paste link to your recipe app on Google Play Store or App Store. https://play.google.com/store/apps/";
            Clipboard.setData(ClipboardData(text: text));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Copied to clipboard!')),
            );
          },
        ),
      ],
    );
  }
}
