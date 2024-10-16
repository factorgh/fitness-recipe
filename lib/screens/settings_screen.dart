// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:fit_cibus/providers/user_provider.dart';
import 'package:fit_cibus/screens/account_screen.dart';
import 'package:fit_cibus/screens/general_screen.dart';
import 'package:fit_cibus/screens/login_screen.dart';
import 'package:fit_cibus/screens/notify_screen.dart';
import 'package:fit_cibus/screens/profile_screen.dart';
import 'package:fit_cibus/utils/native_alert.dart';
import 'package:fit_cibus/widgets/reusable_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
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

  Future<void> _logout() async {
    ref.read(userProvider.notifier).clearUser();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('auth_token', '');

    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const LoginScreen()));
    NativeAlerts().showSuccessAlert(context, "Logged Out successfully");
  }
}
