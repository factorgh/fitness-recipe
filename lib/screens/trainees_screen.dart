// ignore_for_file: avoid_print, unused_result

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voltican_fitness/models/user.dart';
import 'package:voltican_fitness/providers/trainer_provider.dart';
import 'package:voltican_fitness/providers/user_provider.dart';

final followingIdsProvider = StateProvider<List<String>>((ref) => []);
final filterProvider = StateProvider<String>((ref) => 'Followers');
final traineeFilterProvider = StateProvider<String>((ref) => 'All');

class TraineesScreen extends ConsumerStatefulWidget {
  const TraineesScreen({super.key});

  @override
  ConsumerState<TraineesScreen> createState() => _TraineesScreenState();
}

class _TraineesScreenState extends ConsumerState<TraineesScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedTrainerFilter = ref.watch(filterProvider);
    final selectedTraineeFilter = ref.watch(traineeFilterProvider);
    final trainer = ref.watch(userProvider);
    final trainerId = trainer?.id;

    if (trainerId == null) {
      return Scaffold(
        appBar: AppBar(
          leading: const SizedBox(),
          title: const Text(
            'Trainees & Trainers',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          centerTitle: true,
        ),
        body: const Center(child: Text('No trainer selected')),
      );
    }

    final followersAsync = ref.watch(followersProvider(trainerId));
    final followingTrainersAsync =
        ref.watch(followingTrainersProvider(trainerId));
    final followingIds = ref.watch(followingIdsProvider);

    void followTrainer(String trainerToFollowId) {
      ref
          .read(followersProvider(trainerId).notifier)
          .followTrainer(trainerId, trainerToFollowId);
      ref
          .read(followingIdsProvider.notifier)
          .update((state) => [...state, trainerToFollowId]);
    }

    void unfollowTrainer(String trainerToUnfollowId) {
      ref
          .read(followersProvider(trainerId).notifier)
          .unfollowTrainer(trainerId, trainerToUnfollowId);
      ref.read(followingIdsProvider.notifier).update(
          (state) => state.where((id) => id != trainerToUnfollowId).toList());
    }

    void removeTrainee(String traineeId) {
      // Implement your logic to remove the trainee
      print('Remove trainee: $traineeId');
    }

    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox(),
        title: const Text(
          'Trainees & Trainers',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          TabBar(
            controller: tabController,
            indicatorColor: Colors.red,
            labelColor: Colors.red,
            unselectedLabelColor: Colors.black,
            tabs: const [
              Tab(text: 'Trainees'),
              Tab(text: 'Trainers'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                // Trainees Tab
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: DropdownButton<String>(
                        value: selectedTraineeFilter,
                        onChanged: (newValue) {
                          ref.read(traineeFilterProvider.notifier).state =
                              newValue!;
                          ref.refresh(followersProvider(
                              trainerId)); // Refresh data with new filter
                        },
                        items: const [
                          DropdownMenuItem(value: 'All', child: Text('All')),
                          DropdownMenuItem(
                              value: 'Assigned', child: Text('Assigned')),
                        ],
                      ),
                    ),
                    Expanded(
                      child: followersAsync.when(
                        data: (followers) {
                          final trainees = followers['trainees'] ?? [];
                          final filteredTrainees =
                              selectedTraineeFilter == 'All'
                                  ? trainees
                                  : trainees.where((user) {
                                      // Implement your logic to filter assigned trainees here
                                      return false; // Replace with your actual logic
                                    }).toList();

                          return buildTraineesListView(
                            filteredTrainees,
                            followingIds,
                            followTrainer,
                            unfollowTrainer,
                            removeTrainee,
                          );
                        },
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (err, _) => Center(child: Text('Error: $err')),
                      ),
                    ),
                  ],
                ),
                // Trainers Tab
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: DropdownButton<String>(
                        value: selectedTrainerFilter,
                        onChanged: (newValue) {
                          ref.read(filterProvider.notifier).state = newValue!;
                          ref.refresh(followingTrainersProvider(
                              trainerId)); // Refresh data with new filter
                        },
                        items: const [
                          DropdownMenuItem(
                              value: 'Following', child: Text('Following')),
                          DropdownMenuItem(
                              value: 'Followers', child: Text('Followers')),
                        ],
                      ),
                    ),
                    Expanded(
                      child: followingTrainersAsync.when(
                        data: (followingTrainers) {
                          final filteredTrainers = selectedTrainerFilter ==
                                  'Following'
                              ? followingTrainers
                              : followingTrainers; // Show all trainers for 'Followers' filter

                          return buildTrainersListView(
                            filteredTrainers,
                            followingIds,
                            followTrainer,
                            unfollowTrainer,
                          );
                        },
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (err, _) => Center(child: Text('Error: $err')),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTraineesListView(
    List<User> trainees,
    List<String> followingIds,
    Function(String) follow,
    Function(String) unfollow,
    Function(String)? removeTrainee,
  ) {
    return ListView.builder(
      itemCount: trainees.length,
      itemBuilder: (context, index) {
        final trainee = trainees[index];
        final isFollowing = followingIds.contains(trainee.id);

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: trainee.imageUrl != null
                      ? NetworkImage(trainee.imageUrl!)
                      : null,
                  backgroundColor: Colors.blue,
                  child: trainee.imageUrl == null
                      ? Text(
                          trainee.fullName[0].toUpperCase(),
                          style: const TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        trainee.fullName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(trainee.username),
                    ],
                  ),
                ),
                if (isFollowing && removeTrainee != null)
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.grey),
                    onPressed: () => showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Remove Trainee'),
                          content: const Text(
                              'Are you sure you want to remove this trainee?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                removeTrainee(trainee.id);
                                Navigator.of(context).pop();
                              },
                              child: const Text('Remove'),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildTrainersListView(
    List<User> trainers,
    List<String> followingIds,
    Function(String) follow,
    Function(String) unfollow,
  ) {
    return ListView.builder(
      itemCount: trainers.length,
      itemBuilder: (context, index) {
        final trainer = trainers[index];
        final isFollowing = followingIds.contains(trainer.id);

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: trainer.imageUrl != null
                      ? NetworkImage(trainer.imageUrl!)
                      : null,
                  backgroundColor: Colors.blue,
                  child: trainer.imageUrl == null
                      ? Text(
                          trainer.fullName[0].toUpperCase(),
                          style: const TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        trainer.fullName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(trainer.username),
                    ],
                  ),
                ),
                if (!isFollowing)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.green),
                    onPressed: () => unfollow(trainer.id),
                    child: const Text(
                      "Unfollow",
                      style: TextStyle(fontSize: 10),
                    ),
                  ),
                if (isFollowing)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.red),
                    onPressed: () => unfollow(trainer.id),
                    child: const Text(
                      "Unfollow",
                      style: TextStyle(fontSize: 10),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
