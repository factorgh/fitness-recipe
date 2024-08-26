// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voltican_fitness/Features/trainer/trainer_service.dart';
import 'package:voltican_fitness/providers/user_provider.dart';
import 'package:voltican_fitness/screens/login_screen.dart';
import 'package:voltican_fitness/screens/tabs_screen.dart';
import 'package:voltican_fitness/services/auth_service.dart';
import 'package:voltican_fitness/utils/native_alert.dart';

class CodeScreen extends ConsumerStatefulWidget {
  const CodeScreen({super.key});

  @override
  ConsumerState<CodeScreen> createState() => _CodeScreenState();
}

class _CodeScreenState extends ConsumerState<CodeScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _codeController = TextEditingController();
  Map<String, dynamic>? user;
  bool isLoading = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> getUserByCode(BuildContext context, String code) async {
    setState(() {
      isLoading = true;
    });

    try {
      final userData = await _authService.getUserByCode(code);

      if (userData != null) {
        setState(() {
          user = userData;
        });
        _showTrainerDetails(context);
      } else {
        NativeAlerts().showErrorAlert(context, 'Trainer does not exist');
      }
    } catch (e) {
      print('Error fetching user by code: $e');
      NativeAlerts().showErrorAlert(context, 'An error occurred');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showTrainerDetails(BuildContext context) {
    if (user != null) {
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
                  const SizedBox(height: 10),
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.black12,
                    backgroundImage: NetworkImage(
                      user?['imageUrl'] ??
                          'https://cdn.pixabay.com/photo/2018/11/13/21/43/avatar-3814049_1280.png',
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    user?['fullName'] ?? 'Unknown',
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton(
                    onPressed: () async {
                      try {
                        final userId = ref.read(userProvider)?.id;
                        if (userId != null && user?["_id"] != null) {
                          await TrainerService().followTrainer(
                            userId,
                            user!["_id"],
                            context,
                          );
                          Navigator.pop(context);
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) =>
                                  const TabsScreen(userRole: '0'),
                            ),
                          );
                          NativeAlerts().showSuccessAlert(context,
                              "Welcome to fitness recipe. We are excited to have you on board! Explore the app to discover amazing features and content tailored just for you");
                        } else {
                          NativeAlerts().showErrorAlert(
                              context, 'Failed to retrieve user details');
                        }
                      } catch (e) {
                        print('Error following trainer: $e');
                        Navigator.pop(context); // Close dialog on error
                        NativeAlerts().showErrorAlert(
                            context, 'Failed to follow trainer');
                      }
                    },
                    child: const Text("Confirm trainer"),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  Future<void> _logout() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token'); // Remove the auth token

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );

      Future.delayed(const Duration(milliseconds: 500), () {
        NativeAlerts().showSuccessAlert(context, "Logged out successfully");
      });
    } catch (e) {
      print('Error logging out: $e');
      NativeAlerts().showErrorAlert(context, 'Failed to log out');
    }
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
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: _logout,
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
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      controller: _codeController,
                      decoration: InputDecoration(
                        labelText: 'Enter your code',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_codeController.text.trim().isNotEmpty) {
                          getUserByCode(context, _codeController.text.trim());
                        } else {
                          NativeAlerts()
                              .showErrorAlert(context, 'Please enter a code');
                        }
                      },
                      child: isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text("Confirm code"),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
