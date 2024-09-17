// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class GeneralScreen extends StatefulWidget {
  const GeneralScreen({super.key});

  @override
  _GeneralScreenState createState() => _GeneralScreenState();
}

class _GeneralScreenState extends State<GeneralScreen> {
  bool _darkMode = false;
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'General Settings',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 25),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _SettingItem(
              icon: Icons.palette,
              title: 'Dark Mode',
              trailing: Switch(
                value: _darkMode,
                onChanged: (value) {
                  setState(() {
                    _darkMode = value;
                    // Add your theme change logic here
                  });
                },
              ),
            ),
            _SettingItem(
              icon: Icons.notifications,
              title: 'Enable Notifications',
              trailing: Switch(
                value: _notificationsEnabled,
                onChanged: (value) {
                  setState(() {
                    _notificationsEnabled = value;
                    // Add your notification toggle logic here
                  });
                },
              ),
            ),
            _SettingItem(
              icon: Icons.volume_up,
              title: 'Notification Sound',
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navigate to notification sound settings
              },
            ),
            const _SettingItem(
              icon: Icons.info,
              title: 'App Version',
              trailing: Text('1.0.0'),
            ),
            _SettingItem(
              icon: Icons.book,
              title: 'Terms of Service',
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navigate to terms of service
              },
            ),
            _SettingItem(
              icon: Icons.privacy_tip,
              title: 'Privacy Policy',
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navigate to privacy policy
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget trailing;
  final VoidCallback? onTap;

  const _SettingItem({
    required this.icon,
    required this.title,
    required this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.black54),
      title: Text(title),
      trailing: trailing,
      onTap: onTap,
    );
  }
}
