// ignore_for_file: avoid_print

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

  // initialize the user from the UserProvider
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await authService.getMe(context: context, ref: ref);
  }

  void goToTabsScreen(BuildContext ctx) {
//     final user = ref.read(userProvider);

//     if (user == null) {
//       return;
//     }
// // Check if it a trainer
//     if (selectedRole == 'Trainer') {
//       // Generate a code if it's a trainer!
//       String generatedCode = codeGenerator.generateCode(user.fullName);
//       print(generatedCode);

//       // Perform update functionality here before navigating to the tabs screen
//       authService.updateRoleAndCode(
//           context: context,
//           ref: ref,
//           code: generatedCode,
//           role: "1",
//           id: user.id);
//     }

// Perform update functionality here before navigating to the tabs screen

    Navigator.of(context).push(MaterialPageRoute(
      builder: (ctx) => selectedRole == 'Trainer'
          ? const TabsScreen(
              userRole: '1',
            )
          : const CodeScreen(),
    ));
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
                    const SizedBox(height: 20),
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
                    width: double
                        .infinity, // Ensures the button takes up the full width
                    child: ElevatedButton(
                      onPressed: () => goToTabsScreen(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, // Background color
                        foregroundColor: Colors.white, // Text color
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Proceed',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
