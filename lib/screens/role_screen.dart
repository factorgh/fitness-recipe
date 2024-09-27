// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voltican_fitness/providers/user_provider.dart';
import 'package:voltican_fitness/screens/code_screen.dart';
import 'package:voltican_fitness/screens/tabs_screen.dart';
import 'package:voltican_fitness/services/auth_service.dart';
import 'package:voltican_fitness/utils/code_generator.dart';
import 'package:voltican_fitness/widgets/reusable_button.dart';
import 'package:voltican_fitness/widgets/role_widget.dart';

class RoleScreen extends ConsumerStatefulWidget {
  const RoleScreen({super.key});

  @override
  ConsumerState<RoleScreen> createState() => _RoleScreenState();
}

class _RoleScreenState extends ConsumerState<RoleScreen>
    with WidgetsBindingObserver {
  String? selectedRole;
  AuthService authService = AuthService();
  final CodeGenerator codeGenerator = CodeGenerator();
  bool isLoading = false; // Add this

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addObserver(this); // Add the observer for app lifecycle
  }

  @override
  void dispose() {
    WidgetsBinding.instance
        .removeObserver(this); // Remove the observer when widget is disposed
    super.dispose();
  }

  // This method will handle app lifecycle changes
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached ||
        state == AppLifecycleState.paused) {
      // If no role is selected and the app is closed or backgrounded, reset the user provider
      if (selectedRole == null) {
        ref.read(userProvider.notifier).clearUser();
      }
    }
    super.didChangeAppLifecycleState(state);
  }

  Future<void> goToTabsScreen(BuildContext ctx) async {
    setState(() {
      isLoading = true;
    });

    try {
      if (selectedRole == 'Trainer') {
        // Perform update functionality here before navigating to the tabs screen
        await authService.updateRole(
          ref: ref,
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
                      child: isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.redAccent),
                            )
                          : Reusablebutton(
                              text: "Proceed",
                              onPressed: isLoading
                                  ? null
                                  : () => goToTabsScreen(context),
                            )),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
