import 'package:flutter/material.dart';
import 'package:voltican_fitness/screens/account_screen.dart';
import 'package:voltican_fitness/screens/general_screen.dart';
import 'package:voltican_fitness/Features/auth/presentation/pages/login_screen.dart';
import 'package:voltican_fitness/screens/notify_screen.dart';
import 'package:voltican_fitness/screens/profile_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox(),
        centerTitle: true,
        title: const Text(
          'Settings',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(top: 20),
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: <Widget>[
              _buildProfileSection(),
              _buildAccountSection(),
              _buildNotificationSection(),
              _buildGeneralSection(),
              _buildLogoutButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        );
      },
      child: const Card(
        child: ListTile(
          leading: Icon(Icons.person),
          title: Text('Profile'),
          subtitle: Text('Edit your profile information'),
        ),
      ),
    );
  }

  Widget _buildAccountSection() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const AccountScreen()),
        );
      },
      child: const Card(
        child: ListTile(
          leading: Icon(Icons.security),
          title: Text('Account'),
          subtitle: Text('Change password or manage account settings'),
        ),
      ),
    );
  }

  Widget _buildNotificationSection() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => NotificationsScreen()),
        );
      },
      child: const Card(
        child: ListTile(
          leading: Icon(Icons.notifications),
          title: Text('Notifications'),
          subtitle: Text('Manage notification preferences'),
        ),
      ),
    );
  }

  Widget _buildGeneralSection() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const GeneralScreen()),
        );
      },
      child: const Card(
        child: ListTile(
          leading: Icon(Icons.settings),
          title: Text('General'),
          subtitle: Text('Manage app settings and preferences'),
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15),
          backgroundColor: Colors.red, // Background color
          foregroundColor: Colors.white, // Text color
        ),
        child: const Text('Logout'),
        onPressed: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        },
      ),
    );
  }
}
