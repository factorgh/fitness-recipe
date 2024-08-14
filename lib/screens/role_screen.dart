import 'package:flutter/material.dart';
import 'package:voltican_fitness/screens/code_screen.dart';
import 'package:voltican_fitness/screens/tabs_screen.dart';
import 'package:voltican_fitness/widgets/role_widget.dart';

class RoleScreen extends StatefulWidget {
  const RoleScreen({super.key});

  @override
  State<RoleScreen> createState() => _RoleScreenState();
}

class _RoleScreenState extends State<RoleScreen> {
  String? selectedRole;

  void goToTabsScreen(BuildContext ctx) {
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
                  child: InkWell(
                    onTap: () => goToTabsScreen(context),
                    splashColor: Colors.purple,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          'Proceed',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
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
