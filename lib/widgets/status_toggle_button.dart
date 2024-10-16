// ignore_for_file: use_build_context_synchronously

import 'package:fit_cibus/providers/user_provider.dart';
import 'package:fit_cibus/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StatusToggleButton extends ConsumerStatefulWidget {
  const StatusToggleButton({super.key});

  @override
  _StatusToggleButtonState createState() => _StatusToggleButtonState();
}

class _StatusToggleButtonState extends ConsumerState<StatusToggleButton> {
  bool isPublic = true;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                'Status',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
              const Spacer(),
              Text(
                ' ${isPublic ? 'Public' : 'Private'}',
                style: TextStyle(
                    fontSize: 16, color: isPublic ? Colors.red : Colors.blue),
              ),
            ],
          ),
          GestureDetector(
            onTap: _toggleButton,
            child: Text(
              isPublic ? 'Make Information Private' : 'Make Information Public',
              style: TextStyle(
                color: isPublic ? Colors.blue : Colors.redAccent,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleButton() async {
    setState(() {
      isPublic = !isPublic;
    });

    try {
      final AuthService authService = AuthService();
      final userId = ref.read(userProvider)?.id;
      await authService.updateStatus(
          ref: ref,
          context: context,
          status: isPublic ? 'public' : 'private',
          id: userId!);
    } catch (e) {
      // Handle error, possibly revert status
      setState(() {
        isPublic = !isPublic; // Revert status on failure
      });
      // Show a snackbar or dialog to notify the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update status.')),
      );
    }
  }
}
