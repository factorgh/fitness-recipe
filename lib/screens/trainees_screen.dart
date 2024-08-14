import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voltican_fitness/models/user.dart';
import 'package:voltican_fitness/providers/trainer_provider.dart';
import 'package:voltican_fitness/providers/user_provider.dart';

final followingIdsProvider = StateProvider<List<String>>((ref) => []);

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
    final selectedDropdown = ref.watch(trainerFilterProvider);
    final trainerId =
        ref.watch(userProvider); // Replace with the actual trainer ID

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

    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox(),
        title: const Text('Trainees & Trainers'),
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
                followersAsync.when(
                  data: (followers) => buildListView(followers, false,
                      followingIds, followTrainer, unfollowTrainer),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Center(child: Text('Error: $err')),
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        DropdownButton<String>(
                          value: selectedDropdown,
                          items: ['Following', 'Followers'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            ref.read(trainerFilterProvider.notifier).state =
                                newValue!;
                          },
                        ),
                      ],
                    ),
                    Expanded(
                      child: followingTrainersAsync.when(
                        data: (followingTrainers) => buildListView(
                            followingTrainers,
                            true,
                            followingIds,
                            followTrainer,
                            unfollowTrainer),
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (err, stack) =>
                            Center(child: Text('Error: $err')),
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
    bool isFollowing,
    List<String> followingIds,
    void Function(String) followTrainer,
    void Function(String) unfollowTrainer,
  ) {
    if (users.isEmpty) {
      return Center(
          child:
              Text('No ${isFollowing ? 'Following Trainers' : 'Followers'}'));
    }

    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        final isFollowingUser = followingIds.contains(user.id);

        return ListTile(
          title: Text(user.fullName),
          trailing: isFollowingUser
              ? IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: () => unfollowTrainer(user.id),
                )
              : IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () => followTrainer(user.id),
                ),
        );
      },
    );
  }
}
