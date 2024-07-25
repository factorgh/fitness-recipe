import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          _buildProfileSection(),
          _buildAccountSection(),
          _buildNotificationSection(),
          _buildGeneralSection(),
          _buildLogoutButton(),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.person),
        title: const Text('Profile'),
        subtitle: const Text('Edit your profile information'),
        onTap: () {
          // Navigate to profile screen
        },
      ),
    );
  }

  Widget _buildAccountSection() {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.security),
        title: const Text('Account'),
        subtitle: const Text('Change password or manage account settings'),
        onTap: () {
          // Navigate to account settings screen
        },
      ),
    );
  }

  Widget _buildNotificationSection() {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.notifications),
        title: const Text('Notifications'),
        subtitle: const Text('Manage notification preferences'),
        onTap: () {
          // Navigate to notification settings screen
        },
      ),
    );
  }

  Widget _buildGeneralSection() {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.settings),
        title: const Text('General'),
        subtitle: const Text('Manage app settings and preferences'),
        onTap: () {
          // Navigate to general settings screen
        },
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red, // Background color
          foregroundColor: Colors.white, // Text color
        ),
        child: const Text('Logout'),
        onPressed: () {
          // Handle logout action
        },
      ),
    );
  }
}
