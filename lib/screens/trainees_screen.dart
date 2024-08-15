// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voltican_fitness/models/user.dart';
import 'package:voltican_fitness/providers/trainer_provider.dart';
import 'package:voltican_fitness/providers/user_provider.dart';

final followingIdsProvider = StateProvider<List<String>>((ref) => []);
final filterProvider = StateProvider<String>((ref) => 'Following');
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
    final trainerId = ref.watch(userProvider);

    final followersAsync = ref.watch(followersProvider(trainerId!.id));
    final followingTrainersAsync =
        ref.watch(followingTrainersProvider(trainerId.id));

    final followingIds = ref.watch(followingIdsProvider);

    void followTrainer(String trainerToFollowId) {
      ref
          .read(followersProvider(trainerId.id).notifier)
          .followTrainer(trainerId.id, trainerToFollowId);
      ref
          .read(followingIdsProvider.notifier)
          .update((state) => [...state, trainerToFollowId]);
    }

    void unfollowTrainer(String trainerToUnfollowId) {
      ref
          .read(followersProvider(trainerId.id).notifier)
          .unfollowTrainer(trainerId.id, trainerToUnfollowId);
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
                Column(
                  children: [
                    // Dropdown to filter Trainees
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: DropdownButton<String>(
                        value: selectedTraineeFilter,
                        onChanged: (newValue) {
                          ref.read(traineeFilterProvider.notifier).state =
                              newValue!;
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
                          final filteredFollowers = selectedTraineeFilter ==
                                  'All'
                              ? followers
                                  .where((user) => user.role == '0')
                                  .toList()
                              : followers
                                  .where((user) =>
                                      user.role == '0' &&
                                      // Implement logic to check if trainee is assigned
                                      false) // Replace the false condition with actual logic
                                  .toList();
                          return buildListView(
                            filteredFollowers,
                            false,
                            followingIds,
                            followTrainer,
                            unfollowTrainer,
                            removeTrainee,
                          );
                        },
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (err, _) => Center(child: Text('Error: $err')),
                        // Handle empty state
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    // Dropdown to filter Trainers
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: DropdownButton<String>(
                        value: selectedTrainerFilter,
                        onChanged: (newValue) {
                          ref.read(filterProvider.notifier).state = newValue!;
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
                          final filteredTrainers =
                              selectedTrainerFilter == 'Following'
                                  ? followingTrainers
                                      .where((trainer) =>
                                          followingIds.contains(trainer.id) &&
                                          trainer.role == '1')
                                      .toList()
                                  : followingTrainers
                                      .where((trainer) =>
                                          trainer.role == '1' &&
                                          // Filter based on followers
                                          followersAsync.maybeWhen(
                                            data: (followers) {
                                              return followers.any((follower) =>
                                                  follower.id == trainer.id);
                                            },
                                            orElse: () => false,
                                          ))
                                      .toList();
                          return buildListView(
                            filteredTrainers,
                            true,
                            followingIds,
                            followTrainer,
                            unfollowTrainer,
                            null,
                          );
                        },
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (err, _) => Center(child: Text('Error: $err')),
                        // Handle empty state
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

  Widget buildListView(
    List<User> users,
    bool isTrainerList,
    List<String> followingIds,
    Function(String) follow,
    Function(String) unfollow,
    Function(String)? removeTrainee,
  ) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        final isFollowing = followingIds.contains(user.id);

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: user.imageUrl != null
                      ? NetworkImage(user.imageUrl!)
                      : null,
                  backgroundColor: Colors.blue,
                  child: user.imageUrl == null
                      ? Text(
                          user.fullName[0].toUpperCase(),
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
                        user.fullName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(user.username),
                    ],
                  ),
                ),
                if (isTrainerList && isFollowing)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.red),
                    onPressed: () => unfollow(user.id),
                    child: const Text(
                      "Unfollow",
                      style: TextStyle(fontSize: 10),
                    ),
                  ),
                if (!isTrainerList && removeTrainee != null)
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
                                removeTrainee(user.id);
                                Navigator.of(context).pop();
                              },
                              child: const Text('Remove'),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                if (!isTrainerList && !isFollowing)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.green),
                    onPressed: () => follow(user.id),
                    child: const Text(
                      "Follow",
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
