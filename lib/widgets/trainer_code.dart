// ignore_for_file: use_build_context_synchronously

import 'package:fit_cibus/providers/trainer_provider.dart';
import 'package:fit_cibus/providers/user_provider.dart';
import 'package:fit_cibus/screens/code_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TrainerCodeWidget extends ConsumerStatefulWidget {
  final String trainerName;
  final String trainerId;
  const TrainerCodeWidget(
      {super.key, required this.trainerName, required this.trainerId});

  @override
  _TrainerCodeWidgetState createState() => _TrainerCodeWidgetState();
}

class _TrainerCodeWidgetState extends ConsumerState<TrainerCodeWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                "Trainer Name",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
              const Spacer(),
              Text(
                widget.trainerName,
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 16),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () {
              _showConfirmationDialog(widget.trainerId);
            },
            child: const Text(
              "Change Your Trainer",
              style: TextStyle(
                  color: Colors.red, fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  void _showConfirmationDialog(String trainerToUnfollowId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Change Trainer"),
          content: const Text(
            "Do you want to change your trainer? Changing trainer will log you out of the current trainer's account.",
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("OK"),
              onPressed: () async {
                // Perform the unfollow operation
                final trainerId = ref.read(userProvider)!.id;
                await ref
                    .read(followingTrainersProvider(trainerId).notifier)
                    .unfollowTrainer(trainerId, trainerToUnfollowId);

                await ref
                    .read(followingTrainersProvider(trainerId).notifier)
                    .fetchFollowingTrainers(trainerId);

                // Navigate to the CodeScreen
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CodeScreen()),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
