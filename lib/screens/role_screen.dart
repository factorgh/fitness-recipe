import 'package:flutter/material.dart';
import 'package:voltican_fitness/screens/tabs_screen.dart';
import 'package:voltican_fitness/widgets/button.dart';
import 'package:voltican_fitness/widgets/role_widget.dart';

class RoleScreen extends StatefulWidget {
  const RoleScreen({super.key});

  @override
  State<RoleScreen> createState() => _RoleScreenState();
}

class _RoleScreenState extends State<RoleScreen> {
  void goToTabsScreen(BuildContext ctx) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => const TabsScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: 100,
        ),
        Container(
          margin: const EdgeInsets.only(left: 20),
          child: const Text(
            'Select your role ',
            style: TextStyle(
                fontSize: 25, color: Colors.black, fontWeight: FontWeight.w500),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Container(
          margin: const EdgeInsets.only(left: 20),
          child: const Text(
            'Identify yourself:Trainer or trainee',
            style: TextStyle(color: Color.fromARGB(255, 133, 132, 132)),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        const Divider(
          color: Color.fromARGB(255, 249, 189, 189),
          height: 1.5,
        ),
        const SizedBox(
          height: 120,
        ),
        const Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            RoleItemWidget(labelText: 'Trainer'),
            RoleItemWidget(labelText: 'Trainee')
          ],
        ),
        const SizedBox(
          height: 120,
        ),
        InkWell(
          onTap: () {
            goToTabsScreen(context);
          },
          splashColor: Colors.purple,
          child: Container(
            margin: const EdgeInsets.only(left: 20, right: 20),
            child: const ButtonWidget(
                backColor: Colors.red,
                text: 'Proceed',
                textColor: Colors.white),
          ),
        )
      ],
    ));
  }
}
