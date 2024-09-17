// ignore_for_file: unused_result

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voltican_fitness/models/user.dart';
import 'package:voltican_fitness/providers/assigned_trainees_provider.dart';

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
    final selectedTraineeFilter = ref.watch(traineeFilterProvider);
    final selectedTrainerFilter = ref.watch(filterProvider);
    final trainer = ref.watch(userProvider);
    final trainerId = trainer?.id;

    if (trainerId == null) {
      return Scaffold(
        appBar: AppBar(
          leading: const SizedBox(),
          title: const Text(
            'Trainees & Trainers',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          centerTitle: true,
        ),
        body: const Center(child: Text('No trainer selected')),
      );
    }

    final followersAsync = ref.watch(followersProvider(trainerId));
    final assignedTraineesAsync =
        ref.watch(assignedTraineesProvider(trainerId));
    final followingTrainersAsync =
        ref.watch(followingTrainersProvider(trainerId));
    final followingIds = ref.watch(followingIdsProvider);

    void unfollowTrainer(String trainerToUnfollowId) {
      ref
          .read(followersProvider(trainerId).notifier)
          .unfollowTrainer(trainerId, trainerToUnfollowId)
          .then((_) {
        ref.refresh(followingTrainersProvider(trainerId));
        ref.refresh(followersProvider(trainerId));
        ref.refresh(followingIdsProvider);
      });
    }

    void removeFollower(String followerId) {
      ref
          .read(followersProvider(trainerId).notifier)
          .removeFollower(trainerId, followerId)
          .then((_) {
        ref.refresh(followersProvider(trainerId));
        ref.refresh(followingTrainersProvider(trainerId));
      });
    }

    void removeTrainee(String traineeId) {
      // Implement your logic to remove the trainee and refresh the assignedTraineesProvider
      ref.refresh(assignedTraineesProvider(trainerId));
    }

    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox(),
        title: const Text(
          'Trainees & Trainers',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 25),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          TabBar(
            controller: tabController,
            indicatorColor: Colors.redAccent,
            labelColor: Colors.redAccent,
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
                        },
                        items: const [
                          DropdownMenuItem(value: 'All', child: Text('All')),
                          DropdownMenuItem(
                              value: 'Assigned', child: Text('Assigned')),
                        ],
                      ),
                    ),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          ref.refresh(followersProvider(trainerId));
                          ref.refresh(assignedTraineesProvider(trainerId));
                        },
                        child: selectedTraineeFilter == 'All'
                            ? followersAsync.when(
                                data: (followers) {
                                  final trainees = followers['trainees'] ?? [];
                                  if (trainees.isEmpty) {
                                    return const Center(
                                        child: Text('No trainees found'));
                                  }
                                  return buildTraineesListView(
                                    trainees,
                                    followingIds,
                                    unfollowTrainer,
                                    removeTrainee,
                                    assignedTrainees: [],
                                  );
                                },
                                loading: () => const Center(
                                    child: CircularProgressIndicator()),
                                error: (err, _) =>
                                    Center(child: Text('Error: $err')),
                              )
                            : assignedTraineesAsync.when(
                                data: (assignedTrainees) {
                                  if (assignedTrainees.isEmpty) {
                                    return const Center(
                                        child:
                                            Text('No assigned trainees found'));
                                  }
                                  return buildTraineesListView(
                                    assignedTrainees,
                                    followingIds,
                                    unfollowTrainer,
                                    removeTrainee,
                                    assignedTrainees: assignedTrainees,
                                  );
                                },
                                loading: () => const Center(
                                    child: CircularProgressIndicator()),
                                error: (err, _) =>
                                    Center(child: Text('Error: $err')),
                              ),
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
                      child: RefreshIndicator(
                        onRefresh: () async {
                          ref.refresh(followersProvider(trainerId));
                          ref.refresh(followingTrainersProvider(trainerId));
                        },
                        child: selectedTrainerFilter == 'Following'
                            ? followingTrainersAsync.when(
                                data: (followingTrainers) {
                                  return buildTrainersListView(
                                    followingTrainers,
                                    followingIds,
                                    unfollowTrainer,
                                    isFollowingView: true,
                                  );
                                },
                                loading: () => const Center(
                                    child: CircularProgressIndicator()),
                                error: (err, _) =>
                                    Center(child: Text('Error: $err')),
                              )
                            : followersAsync.when(
                                data: (followers) {
                                  final trainers = followers['trainers'] ?? [];
                                  return buildTrainersListView(
                                    trainers,
                                    followingIds,
                                    unfollowTrainer,
                                    removeFollower: removeFollower,
                                  );
                                },
                                loading: () => const Center(
                                    child: CircularProgressIndicator()),
                                error: (err, _) =>
                                    Center(child: Text('Error: $err')),
                              ),
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
    Function(String) unfollow,
    Function(String)? removeTrainee, {
    required List<User> assignedTrainees,
  }) {
    final assignedTraineesIds = assignedTrainees.map((t) => t.id).toSet();

    if (trainees.isEmpty) {
      return const Center(
        child: Text('No trainees found'),
      );
    }
    return ListView.builder(
      itemCount: trainees.length,
      itemBuilder: (context, index) {
        final trainee = trainees[index];
        final isFollowing = followingIds.contains(trainee.id);
        final isAssigned = assignedTraineesIds.contains(trainee.id);

        return Card(
          color: isAssigned
              ? Colors
                  .lightBlue.shade100 // Different color for assigned trainees
              : (trainee.id.isNotEmpty && followingIds.contains(trainee.id)
                  ? Colors.green.shade100
                  : Colors.white),
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
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                              },
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                removeTrainee(trainee.id);
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
    Function(String) unfollowTrainer, {
    Function(String)? removeFollower,
    bool isFollowingView = false,
  }) {
    if (trainers.isEmpty) {
      return Center(
        child: Text(isFollowingView
            ? 'You are not following any trainers'
            : 'No followers found'),
      );
    }
    return ListView.builder(
      itemCount: trainers.length,
      itemBuilder: (context, index) {
        final trainer = trainers[index];
        final isFollowing = followingIds.contains(trainer.id);

        return Card(
          color: isFollowing ? Colors.green.shade100 : Colors.white,
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
                if (isFollowingView)
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.grey),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Unfollow Trainer'),
                            content: const Text(
                                'Are you sure you want to unfollow this trainer?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  unfollowTrainer(trainer.id);
                                  setState(() {});
                                },
                                child: const Text('Unfollow'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  )
                else if (removeFollower != null)
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.grey),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Remove Follower'),
                            content: const Text(
                                'Are you sure you want to remove this follower?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  removeFollower(trainer.id);
                                  setState(() {});
                                },
                                child: const Text('Remove'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
