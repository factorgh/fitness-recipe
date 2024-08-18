// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:voltican_fitness/screens/code_screen.dart';
import 'package:voltican_fitness/screens/tabs_screen.dart';
import 'package:voltican_fitness/services/auth_service.dart';
import 'package:voltican_fitness/utils/code_generator.dart';
import 'package:voltican_fitness/widgets/role_widget.dart';

class RoleScreen extends ConsumerStatefulWidget {
  const RoleScreen({super.key});

  @override
  ConsumerState<RoleScreen> createState() => _RoleScreenState();
}

class _RoleScreenState extends ConsumerState<RoleScreen> {
  String? selectedRole;
  AuthService authService = AuthService();
  final CodeGenerator codeGenerator = CodeGenerator();
  bool isLoading = false; // Add this

  @override
  void initState() {
    super.initState();
  }

  Future<void> goToTabsScreen(BuildContext ctx) async {
    setState(() {
      isLoading = true; // Set loading state to true
    });

    try {
      if (selectedRole == 'Trainer') {
        // Perform update functionality here before navigating to the tabs screen
        await authService.updateRole(
          context: context,
          role: "1",
        );

        Navigator.of(context).push(MaterialPageRoute(
          builder: (ctx) => const TabsScreen(
            userRole: '1',
          ),
        ));
      } else if (selectedRole == 'Trainee') {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (ctx) => const CodeScreen(),
        ));
      }
    } catch (e) {
      // Handle error here if necessary
    } finally {
      setState(() {
        isLoading = false; // Set loading state to false after processing
      });
    }
  }

  void _selectRole(String role) {
    setState(() {
      selectedRole = role;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              const Text(
                'Select your role',
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Identify yourself: Trainer or Trainee',
                style: TextStyle(
                  color: Color(0xFF858484),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              const Divider(
                color: Color(0xFFF9BDBD),
                thickness: 1.5,
              ),
              const SizedBox(height: 30),
              Expanded(
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => _selectRole('Trainer'),
                      child: RoleItemWidget(
                        imagePath: "assets/images/role2.png",
                        labelText: 'Trainer',
                        isSelected: selectedRole == 'Trainer',
                      ),
                    ),
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: () => _selectRole('Trainee'),
                      child: RoleItemWidget(
                        imagePath: "assets/images/role1.png",
                        labelText: 'Trainee',
                        isSelected: selectedRole == 'Trainee',
                      ),
                    ),
                  ],
                ),
              ),
              if (selectedRole != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                          isLoading ? null : () => goToTabsScreen(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white) // Show a loading spinner
                          : const Text(
                              'Proceed',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
