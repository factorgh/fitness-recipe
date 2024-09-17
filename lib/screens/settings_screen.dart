// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:voltican_fitness/providers/user_provider.dart';
import 'package:voltican_fitness/screens/account_screen.dart';
import 'package:voltican_fitness/screens/general_screen.dart';
import 'package:voltican_fitness/screens/login_screen.dart';

import 'package:voltican_fitness/screens/notify_screen.dart';
import 'package:voltican_fitness/screens/profile_screen.dart';
import 'package:voltican_fitness/utils/native_alert.dart';
import 'package:voltican_fitness/widgets/reusable_button.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  Future<void> _logout() async {
    ref.read(userProvider.notifier).clearUser();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('auth_token', '');

    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const LoginScreen()));
    NativeAlerts().showSuccessAlert(context, "Logged Out successfully");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox(),
        centerTitle: true,
        title: const Text(
          'Settings',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
        ),
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(top: 15),
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
    return Reusablebutton(text: "Logout", onPressed: _logout);
  }
}
