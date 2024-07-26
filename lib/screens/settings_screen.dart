import 'package:flutter/material.dart';
import 'package:voltican_fitness/screens/account_screen.dart';
import 'package:voltican_fitness/screens/general_screen.dart';
import 'package:voltican_fitness/screens/login_screen.dart';
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
        leading: Icon(Icons.notifications),
        centerTitle: true,
        title: Text(
          'Settings',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(
                Icons.help_outline,
                color: Colors.red,
              ),
              onPressed: () {
                // Add your help action here
              },
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(top: 20),
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
          MaterialPageRoute(builder: (context) => ProfileScreen()),
        );
      },
      child: Card(
        child: ListTile(
          leading: const Icon(Icons.person),
          title: const Text('Profile'),
          subtitle: const Text('Edit your profile information'),
        ),
      ),
    );
  }

  Widget _buildAccountSection() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => AccountScreen()),
        );
      },
      child: Card(
        child: ListTile(
          leading: const Icon(Icons.security),
          title: const Text('Account'),
          subtitle: const Text('Change password or manage account settings'),
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
      child: Card(
        child: ListTile(
          leading: const Icon(Icons.notifications),
          title: const Text('Notifications'),
          subtitle: const Text('Manage notification preferences'),
        ),
      ),
    );
  }

  Widget _buildGeneralSection() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => GeneralScreen()),
        );
      },
      child: Card(
        child: ListTile(
          leading: const Icon(Icons.settings),
          title: const Text('General'),
          subtitle: const Text('Manage app settings and preferences'),
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 15),
          backgroundColor: Colors.red, // Background color
          foregroundColor: Colors.white, // Text color
        ),
        child: const Text('Logout'),
        onPressed: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        },
      ),
    );
  }
}
