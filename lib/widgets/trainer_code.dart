import 'package:flutter/material.dart';
import 'package:voltican_fitness/screens/login_screen.dart';

class TrainerCodeWidget extends StatefulWidget {
  const TrainerCodeWidget({super.key});

  @override
  _TrainerCodeWidgetState createState() => _TrainerCodeWidgetState();
}

class _TrainerCodeWidgetState extends State<TrainerCodeWidget> {
  bool _showTextField = false;
  final TextEditingController _controller = TextEditingController();

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
                  setState(() {
                    _showTextField = value;
                  });
                },
              ),
              const Text(
                "Change Your Trainer",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          if (_showTextField)
            Column(
              children: [
                TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: 'Enter trainer code',
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    // Handle the confirm action here
                    final trainerCode = _controller.text;
                    // Do something with the trainer code
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Trainer code: $trainerCode')),
                    );

                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
                  },
                  child: const Text('Confirm'),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
