import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voltican_fitness/services/auth_service.dart';
import 'package:voltican_fitness/providers/user_provider.dart';
import 'package:voltican_fitness/widgets/reusable_button.dart';

class UpdateProfileScreen extends ConsumerStatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends ConsumerState<UpdateProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _fullName;
  late String _username;
  late String _email;

  @override
  void initState() {
    super.initState();
    // Use ref.watch to ensure the state is reactive
    final user = ref.read(userProvider);
    _fullName = user?.fullName ?? '';
    _username = user?.username ?? '';
    _email = user?.email ?? '';
  }

  void _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final user = ref.read(userProvider);
      if (user != null) {
        // Perform the update
        await AuthService().updateUser(
          context: context,
          ref: ref,
          id: user.id,
          fullName: _fullName,
          username: _username,
          email: _email,
        );
        // Update the userProvider with new data
        ref.read(userProvider.notifier).updateUser(
              fullName: _fullName,
              username: _username,
              email: _email,
            );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        'Update Profile',
        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 25),
      )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _fullName,
                decoration: const InputDecoration(labelText: 'Full Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _fullName = value!;
                },
              ),
              TextFormField(
                initialValue: _username,
                decoration: const InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
                onSaved: (value) {
                  _username = value!;
                },
              ),
              TextFormField(
                initialValue: _email,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
                onSaved: (value) {
                  _email = value!;
                },
              ),
              const SizedBox(height: 20),
              Reusablebutton(text: 'Update Profile', onPressed: _updateProfile)
            ],
          ),
        ),
      ),
    );
  }
}
