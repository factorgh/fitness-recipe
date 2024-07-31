import 'package:flutter/material.dart';
import 'package:voltican_fitness/screens/code_screen.dart';

class TrainerCodeWidget extends StatefulWidget {
  const TrainerCodeWidget({super.key});

  @override
  _TrainerCodeWidgetState createState() => _TrainerCodeWidgetState();
}

class _TrainerCodeWidgetState extends State<TrainerCodeWidget> {
  bool _showTextField = false;

  void _showConfirmationDialog(bool newValue) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Change Trainer"),
          content: const Text(
              "Do you want to change your trainer?.Changing trainer will log you out of the current trainers account"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                setState(() {
                  _showTextField = !newValue; // Revert switch state
                });
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CodeScreen()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Switch(
                value: _showTextField,
                onChanged: (value) {
                  _showConfirmationDialog(value);
                },
              ),
              const Text(
                "Change Your Trainer",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
