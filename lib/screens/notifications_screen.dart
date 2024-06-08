import 'package:flutter/material.dart';
import 'package:voltican_fitness/widgets/notification_item.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: [
          const SizedBox(
            height: 80,
          ),
          Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Icon(Icons.arrow_back_ios,
                    size: 25, color: Colors.black),
              ),
              const SizedBox(
                width: 40,
              ),
              const Text(
                'Notifications',
                style: TextStyle(fontSize: 25),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          const Column(
            children: [
              NotificationItem(
                  notiIcon: Icons.restaurant_menu,
                  notiText: "Completed meal plan",
                  notiSubText: "You have upcoming meal plan on ..."),
              NotificationItem(
                  notiIcon: Icons.restaurant_menu,
                  notiText: "Completed meal plan",
                  notiSubText: "You have upcoming meal plan on ..."),
              NotificationItem(
                  notiIcon: Icons.restaurant_menu,
                  notiText: "Completed meal plan",
                  notiSubText: "You have upcoming meal plan on ..."),
              NotificationItem(
                  notiIcon: Icons.restaurant_menu,
                  notiText: "Completed meal plan",
                  notiSubText: "You have upcoming meal plan on ..."),
              NotificationItem(
                  notiIcon: Icons.restaurant_menu,
                  notiText: "Completed meal plan",
                  notiSubText: "You have upcoming meal plan on ..."),
            ],
          )
        ],
      ),
    )));
  }
}
