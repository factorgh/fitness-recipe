// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voltican_fitness/providers/user_provider.dart';
import 'package:voltican_fitness/screens/account_screen.dart';
import 'package:voltican_fitness/screens/general_screen.dart';
import 'package:voltican_fitness/screens/login_screen.dart';
import 'package:voltican_fitness/screens/notify_screen.dart';
import 'package:voltican_fitness/screens/trainee_profile_screen.dart';
import 'package:voltican_fitness/utils/native_alert.dart';

class TraineeSettingsScreen extends ConsumerStatefulWidget {
  const TraineeSettingsScreen({super.key});

  @override
  ConsumerState<TraineeSettingsScreen> createState() =>
      _TraineeSettingsScreenState();
}

class _TraineeSettingsScreenState extends ConsumerState<TraineeSettingsScreen> {
  Future<void> _logout() async {
    ref.read(userProvider.notifier).clearUser();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('auth_token', '');

    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const LoginScreen()));
    NativeAlerts().showSuccessAlert(context, "Logged Out successfully");
    // ); // Adjust route as necessary
  }

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
          MaterialPageRoute(builder: (context) => const TraineeProfileScreen()),
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
          MaterialPageRoute(builder: (context) => const NotificationsScreen()),
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
        onPressed: _logout,
        child: const Text('Logout'),
      ),
    );
  }
}
