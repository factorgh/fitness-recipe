// ignore_for_file: use_build_context_synchronously, avoid_print, unused_result

import 'package:fit_cibus/Features/trainer/trainer_service.dart';
import 'package:fit_cibus/models/user.dart';
import 'package:fit_cibus/providers/trainer_provider.dart';
import 'package:fit_cibus/providers/user_provider.dart';
import 'package:fit_cibus/screens/login_screen.dart';
import 'package:fit_cibus/screens/tabs_screen.dart';
import 'package:fit_cibus/services/auth_service.dart';
import 'package:fit_cibus/utils/native_alert.dart';
import 'package:fit_cibus/widgets/reusable_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CodeScreen extends ConsumerStatefulWidget {
  final String? username;
  const CodeScreen({super.key, this.username});

  @override
  ConsumerState<CodeScreen> createState() => _CodeScreenState();
}

class _CodeScreenState extends ConsumerState<CodeScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _codeController = TextEditingController();
  Map<String, dynamic>? user;
  bool isLoading = false;
  final AuthService authService = AuthService();
  User? userFromLogin;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
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
                    ),
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
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
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
                    const SizedBox(height: 20),
                  ],
                ),
                Center(
                    child: isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.redAccent)
                        : Reusablebutton(
                            text: 'Confirm Code',
                            onPressed: () {
                              if (_codeController.text.trim().isNotEmpty) {
                                getUserByCode(
                                    context, _codeController.text.trim());
                              } else {
                                NativeAlerts().showErrorAlert(
                                    context, 'Please enter a code');
                              }
                            },
                          )),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

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

      if (userData != null && userData.isNotEmpty) {
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

  @override
  void initState() {
    print('--------------------------${widget.username}----------------');
    _fetchUser();
    super.initState();
  }

  void _fetchUser() async {
    await authService.getUserByName(
      username: widget.username!,
      onSuccess: (fetchedUser) {
        setState(() {
          userFromLogin = fetchedUser as User?;
        });
      },
    );

    print('----------------------user From Login-------------------');
    print(userFromLogin);
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

  void _showTrainerDetails(BuildContext context) {
    final currentUser = ref.read(userProvider);
    final selectedUser = userFromLogin ?? currentUser;

    if (selectedUser != null && user != null) {
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
                      user!['imageUrl'] ??
                          'https://cdn.pixabay.com/photo/2018/11/13/21/43/avatar-3814049_1280.png',
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    user!['fullName'] ?? 'Unknown',
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton(
                    onPressed: () async {
                      final trainerId = user?['_id'];

                      if (trainerId != null) {
                        try {
                          await TrainerService().followTrainer(
                              selectedUser.id, trainerId, context);

                          // Refresh trainers provider
                          ref.refresh(followersProvider(trainerId));

                          if (userFromLogin != null) {
                            // Set the user from login and navigate to the login screen
                            ref
                                .read(userProvider.notifier)
                                .setUser(userFromLogin!);
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) =>
                                    const LoginScreen(), // Navigate to HomeScreen
                              ),
                            );
                          } else {
                            // Navigate to TabsScreen if it's the current user from the provider
                            // Refresh trainers provider
                            ref.refresh(followersProvider(trainerId));
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) =>
                                    const TabsScreen(userRole: '0'),
                              ),
                            );
                          }

                          // Show success alert
                          NativeAlerts().showSuccessAlert(context,
                              "Welcome to fitness recipe. We are excited to have you on board! Explore the app to discover amazing features and content tailored just for you.");
                        } catch (e) {
                          print('Error following trainer: $e');
                          Navigator.pop(context); // Close dialog on error
                          NativeAlerts().showErrorAlert(
                              context, 'Failed to follow trainer');
                        }
                      } else {
                        Navigator.pop(context);
                        NativeAlerts().showErrorAlert(
                            context, 'Failed to follow trainer: invalid data');
                      }
                    },
                    child: const Text(
                      "Confirm trainer",
                      style: TextStyle(color: Colors.redAccent),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } else {
      // Handle the case where selectedUser or user is null
      NativeAlerts().showErrorAlert(context, 'Invalid user or trainer data');
    }
  }
}
