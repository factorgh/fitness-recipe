import 'package:flutter/material.dart';
import 'package:voltican_fitness/screens/login_screen.dart';
import 'package:voltican_fitness/screens/tabs_screen.dart';

class CodeScreen extends StatefulWidget {
  const CodeScreen({super.key});

  @override
  State<CodeScreen> createState() => _CodeScreenState();
}

class _CodeScreenState extends State<CodeScreen> {
  bool _showTrainer = false;

  // Show snack bar logic before naviagting to tab screen
  void _showSnackBarAndNavigate(BuildContext context) {
    const snackBar = SnackBar(
      content: Text(
        'Trainer confirmation successful!',
      ),
      duration: Duration(seconds: 2),
      backgroundColor: Colors.red,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    // Wait for the duration of the SnackBar before navigating
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const TabsScreen(userRole: 0)),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Enter trainer's code",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
                      },
                      child: const Icon(
                        Icons.logout,
                        size: 20,
                        color: Colors.blueAccent,
                      ),
                    )
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
                  height: 20,
                ),
                Center(
                  child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _showTrainer = true;
                        });
                      },
                      child: const Text("Confirm code")),
                ),
                const SizedBox(
                  height: 50,
                ),
                // Show trainer details if confirmed
                _showTrainer
                    ? Center(
                        child: Container(
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(20)),
                        child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const CircleAvatar(
                                    radius: 40,
                                    backgroundColor: Colors.black12,
                                    backgroundImage:
                                        AssetImage("assets/images/pf2.jpg"),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text("Albert M.",
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  OutlinedButton(
                                      onPressed: () {
                                        _showSnackBarAndNavigate(context);
                                      },
                                      child: const Text(
                                        "confirm trainer",
                                      )),
                                ],
                              ),
                            )),
                      ))
                    : const SizedBox()
              ],
            )),
      ),
    );
  }
}
