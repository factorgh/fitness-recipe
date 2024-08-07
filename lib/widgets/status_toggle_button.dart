import 'package:flutter/material.dart';

class StatusToggleButton extends StatefulWidget {
  const StatusToggleButton({super.key});

  @override
  _StatusToggleButtonState createState() => _StatusToggleButtonState();
}

class _StatusToggleButtonState extends State<StatusToggleButton> {
  bool isPublic = true; // Default state is public

  void _toggleButton() {
    setState(() {
      isPublic = !isPublic; // Toggle the state
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: _toggleButton,
        child: Text(
          isPublic ? 'Make Information Private' : 'Make Information Public',
          style: TextStyle(
            color: isPublic ? Colors.blue : Colors.red,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
