import 'package:flutter/material.dart';
import 'package:voltican_fitness/Features/auth/presentation/pages/login_screen.dart';
import 'package:voltican_fitness/screens/tabs_screen.dart';

class CodeScreen extends StatefulWidget {
  const CodeScreen({super.key});

  @override
  State<CodeScreen> createState() => _CodeScreenState();
}

class _CodeScreenState extends State<CodeScreen> {
  // Show snack bar logic before navigating to tab screen
  void _showSnackBarAndNavigate(BuildContext context) {
    const snackBar = SnackBar(
      content: Text(
        'Trainer confirmation successful!',
      ),
      duration: Duration(seconds: 2),
      backgroundColor: Colors.blue,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    // Wait for the duration of the SnackBar before navigating

    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const TabsScreen(userRole: 0)),
    );
  }

  void _showTrainerDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 10,
                ),
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.black12,
                  backgroundImage: AssetImage("assets/images/pf2.jpg"),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Albert M.",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _showSnackBarAndNavigate(context);
                  },
                  child: const Text(
                    "Confirm trainer",
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                    },
                    child: const Icon(
                      Icons.logout,
                      size: 20,
                      color: Colors.red,
                    ),
                  )
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 3),
              Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Enter trainer's code",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Enter your code',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        _showTrainerDetails(context);
                      },
                      child: const Text("Confirm code"),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
