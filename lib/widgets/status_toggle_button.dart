import 'package:flutter/material.dart';

class StatusToggleButton extends StatefulWidget {
  const StatusToggleButton({super.key});

  @override
  _StatusToggleButtonState createState() => _StatusToggleButtonState();
}

class _StatusToggleButtonState extends State<StatusToggleButton> {
  bool isPublic = true;

  void _toggleButton() {
    setState(() {
      isPublic = !isPublic;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                'Status',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
              const Spacer(),
              Text(
                ' ${isPublic ? 'Public' : 'Private'}',
                style: TextStyle(
                    fontSize: 16, color: isPublic ? Colors.red : Colors.blue),
              ),
            ],
          ),
          GestureDetector(
            onTap: _toggleButton,
            child: Text(
              isPublic ? 'Make Information Private' : 'Make Information Public',
              style: TextStyle(
                color: isPublic ? Colors.blue : Colors.red,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
