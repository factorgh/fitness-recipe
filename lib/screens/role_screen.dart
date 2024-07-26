import 'package:flutter/material.dart';
import 'package:voltican_fitness/screens/tabs_screen.dart';

import 'package:voltican_fitness/widgets/role_widget.dart';

class RoleScreen extends StatefulWidget {
  const RoleScreen({super.key});

  @override
  State<RoleScreen> createState() => _RoleScreenState();
}

class _RoleScreenState extends State<RoleScreen> {
  void goToTabsScreen(BuildContext ctx) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => const TabsScreen(
              userRole: 0,
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 100),
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
            const SizedBox(height: 8),
            const Divider(
              color: Color(0xFFF9BDBD),
              thickness: 1.5,
            ),
            const SizedBox(height: 80),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                RoleItemWidget(labelText: 'Trainer'),
                RoleItemWidget(labelText: 'Trainee'),
              ],
            ),
            const Spacer(),
            InkWell(
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
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
